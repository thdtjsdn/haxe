(*
 *  Haxe Compiler
 *  Copyright (c)2005 Nicolas Cannasse
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)
open Ast

type error_msg =
	| Unexpected of token
	| Duplicate_default
	| Missing_semicolon
	| Unclosed_macro
	| Unimplemented
	| Missing_type

exception Error of error_msg * pos

let error_msg = function
	| Unexpected t -> "Unexpected "^(s_token t)
	| Duplicate_default -> "Duplicate default"
	| Missing_semicolon -> "Missing ;"
	| Unclosed_macro -> "Unclosed macro"
	| Unimplemented -> "Not implemented for current platform"
	| Missing_type -> "Missing type declaration"

let error m p = raise (Error (m,p))
let display_error : (error_msg -> pos -> unit) ref = ref (fun _ _ -> assert false)

let cache = ref (DynArray.create())
let doc = ref None

let last_token s =
	let n = Stream.count s in
	DynArray.get (!cache) (if n = 0 then 0 else n - 1)

let serror() = raise (Stream.Error "")

let priority = function
	| OpAssign | OpAssignOp _ -> -4
	| OpBoolOr -> -3
	| OpBoolAnd -> -2
	| OpInterval -> -2
	| OpEq | OpNotEq | OpGt | OpLt | OpGte | OpLte | OpPhysEq | OpPhysNotEq -> -1
	| OpOr | OpAnd | OpXor -> 0
	| OpShl | OpShr | OpUShr -> 1
	| OpAdd | OpSub -> 2
	| OpMult | OpDiv -> 3
	| OpMod -> 4

let is_not_assign = function
	| OpAssign | OpAssignOp _ -> false
	| _ -> true

let can_swap _op op =
	let p1 = priority _op in
	let p2 = priority op in
	if p1 < p2 then
		true
	else if p1 = p2 && p1 >= 0 then (* numerical ops are left-assoc *)
		true
	else
		false

let rec make_binop op e ((v,p2) as e2) =
	match v with
	| EBinop (_op,_e,_e2) when can_swap _op op && (is_not_assign _op || is_not_assign op) ->
		let _e = make_binop op e _e in
		EBinop (_op,_e,_e2) , punion (pos _e) (pos _e2)
	| _ ->
		EBinop (op,e,e2) , punion (pos e) (pos e2)

let rec make_unop op ((v,p2) as e) p1 =
	match v with
	| EBinop (bop,e,e2) -> EBinop (bop, make_unop op e p1 , e2) , (punion p1 p2)
	| _ ->
		EUnop (op,Prefix,e), punion p1 p2

let popt f = parser
	| [< v = f >] -> Some v
	| [< >] -> None

let rec plist f = parser
	| [< v = f; l = plist f >] -> v :: l
	| [< >] -> []

let rec psep sep f = parser
	| [< v = f; s >] ->
		let rec loop = parser
			| [< '(sep2,_) when sep2 = sep; v = f; l = loop >] -> v :: l
			| [< >] -> []
		in
		v :: loop s
	| [< >] -> []

let ident = parser
	| [< '(Const (Ident i),_) >] -> i

let any_ident = parser
	| [< '(Const (Ident i),_) >] -> i
	| [< '(Const (Type t),_) >] -> t

let property_ident = parser
	| [< i = any_ident >] -> i
	| [< '(Kwd Default,_) >] -> "default"

let log m s =
	prerr_endline m

let get_doc s =
	let d = !doc in
	doc := None;
	d

let comma = parser
	| [< '(Comma,_) >] -> ()

let semicolon s =
	if fst (last_token s) = BrClose then
		match s with parser
		| [< '(Semicolon,p) >] -> p
		| [< >] -> snd (last_token s)
	else
		match s with parser
		| [< '(Semicolon,p) >] -> p
		| [< s >] -> error Missing_semicolon (snd (last_token s))

let rec	parse_file s =
	doc := None;
	match s with parser
	| [< '(Kwd Package,_); p = parse_package; _ = semicolon; l = plist parse_type_decl; '(Eof,_); >] -> p , l
	| [< l = plist parse_type_decl; '(Eof,_) >] -> [] , l

and parse_type_decl s =
	match s with parser
	| [< '(Kwd Import,p1); p, t, s = parse_import; p2 = semicolon >] -> EImport (p,t,s) , punion p1 p2
	| [< c = parse_common_flags; s >] ->
		match s with parser
		| [< n , p1 = parse_enum_flags; doc = get_doc; '(Const (Type name),_); tl = parse_constraint_params; '(BrOpen,_); l = plist parse_enum; '(BrClose,p2) >] ->
			(EEnum {
				d_name = name;
				d_doc = doc;
				d_params = tl;
				d_flags = List.map snd c @ n;
				d_data = l
			}, punion p1 p2)
		| [< n , p1 = parse_class_flags; doc = get_doc; '(Const (Type name),_); tl = parse_constraint_params; hl = psep Comma parse_class_herit; '(BrOpen,_); fl = plist parse_class_field; '(BrClose,p2) >] ->
			(EClass {
				d_name = name;
				d_doc = doc;
				d_params = tl;
				d_flags = List.map fst c @ n @ hl;
				d_data = fl;
			}, punion p1 p2)
		| [< '(Kwd Typedef,p1); doc = get_doc; '(Const (Type name),p2); tl = parse_constraint_params; '(Binop OpAssign,_); t = parse_type_path >] ->
			(ETypedef {
				d_name = name;
				d_doc = doc;
				d_params = tl;
				d_flags = List.map snd c;
				d_data = t;
			}, punion p1 p2)

and parse_package s = psep Dot ident s

and parse_import = parser
	| [< '(Const (Ident k),_); '(Dot,_); p, t, s = parse_import >] -> (k :: p), t, s
	| [< '(Const (Type t),_); s >] ->
		[] , t , match s with parser
			| [< '(Dot,_); '(Const (Type s),_) >] -> Some s
			| [< >] -> None

and parse_common_flags = parser
	| [< '(Kwd Private,_); l = parse_common_flags >] -> (HPrivate, EPrivate) :: l
	| [< '(Kwd Extern,_); l = parse_common_flags >] -> (HExtern, EExtern) :: l
	| [< >] -> []

and parse_enum_flags = parser
	| [< '(Kwd Enum,p) >] -> [] , p

and parse_class_flags = parser
	| [< '(Kwd Class,p) >] -> [] , p
	| [< '(Kwd Interface,p) >] -> [HInterface] , p

and parse_type_opt = parser
	| [< '(DblDot,_); t = parse_type_path >] -> Some t
	| [< >] -> None

and parse_type_path = parser
	| [< '(POpen,_); t = parse_type_path; '(PClose,_); s >] -> parse_type_path_next (TPParent t) s
	| [< '(BrOpen,_); s >] ->
		let t = (match s with parser
			| [< name = any_ident >] -> TPAnonymous (parse_type_anonymous_resume name s)
			| [< '(Binop OpGt,_); t = parse_type_path_normal; '(Comma,_); s >] ->
				(match s with parser
				| [< name = any_ident; l = parse_type_anonymous_resume name >] -> TPExtend (t,l)
				| [< l = plist (parse_signature_field None); '(BrClose,_) >] -> TPExtend (t,l)
				| [< >] -> serror())
			| [< l = plist (parse_signature_field None); '(BrClose,_) >] -> TPAnonymous l
			| [< >] -> serror()
		) in
		parse_type_path_next t s
	| [< t = parse_type_path_normal; s >] -> parse_type_path_next (TPNormal t) s

and parse_type_path_normal s = parse_type_path1 [] s

and parse_type_path1 pack = parser
	| [< '(Const (Ident name),_); '(Dot,_); t = parse_type_path1 (name :: pack) >] -> t
	| [< '(Const (Type name),_); s >] ->
		let params = (match s with parser
			| [< '(Binop OpLt,_); l = psep Comma parse_type_path_variance; '(Binop OpGt,_) >] -> l
			| [< >] -> []
		) in
		{
			tpackage = List.rev pack;
			tname = name;
			tparams = params
		}

and parse_type_path_variance = parser
	| [< '(Binop OpAdd,_); t = parse_type_path_or_const VCo >] -> t
	| [< '(Binop OpSub,_); t = parse_type_path_or_const VContra >] -> t
	| [< '(Binop OpMult,_); t = parse_type_path_or_const VBi >] -> t
	| [< t = parse_type_path_or_const VNo >] -> t

and parse_type_path_or_const v = parser
	| [< '(Const (String s),_); >] -> TPConst (String s)
	| [< '(Const (Int i),_); >] -> TPConst (Int i)
	| [< '(Const (Float f),_); >] -> TPConst (Float f)
	| [< t = parse_type_path >] -> TPType (v, t)

and parse_type_path_next t = parser
	| [< '(Arrow,_); t2 = parse_type_path >] ->
		(match t2 with
		| TPFunction (args,r) ->
			TPFunction (t :: args,r)
		| _ ->
			TPFunction ([t] , t2))
	| [< >] -> t

and parse_type_anonymous_resume name = parser
	| [< '(DblDot,p); t = parse_type_path; s >] ->
		(name, None, AFVar t, p) ::
		match s with parser
		| [< '(BrClose,_) >] -> []
		| [< '(Comma,_); l = psep Comma parse_type_anonymous; '(BrClose,_) >] -> l
		| [< >] -> serror()

and parse_type_anonymous = parser
	| [< name = any_ident; '(DblDot,p); t = parse_type_path >] -> (name, None, AFVar t, p)

and parse_enum s =
	doc := None;
	match s with parser
	| [< name = any_ident; doc = get_doc; s >] ->
		match s with parser
		| [< '(POpen,_); l = psep Comma parse_enum_param; '(PClose,_); p = semicolon; >] -> (name,doc,l,p)
		| [< '(Semicolon,p) >] -> (name,doc,[],p)
		| [< >] -> serror()

and parse_enum_param = parser
	| [< '(Question,_); name = any_ident; '(DblDot,_); t = parse_type_path >] -> (name,true,t)
	| [< name = any_ident; '(DblDot,_); t = parse_type_path >] -> (name,false,t)

and parse_class_field s =
	doc := None;
	match s with parser
	| [< l = parse_cf_rights true []; doc = get_doc; s >] ->
		match s with parser
		| [< '(Kwd Var,p1); name = any_ident; s >] ->
			(match s with parser
			| [< '(POpen,_); i1 = property_ident; '(Comma,_); i2 = property_ident; '(PClose,_); '(DblDot,_); t = parse_type_path; p2 = semicolon >] ->
				(FProp (name,doc,l,i1,i2,t),punion p1 p2)
			| [< t = parse_type_opt; s >] ->
				let e , p2 = (match s with parser
				| [< '(Binop OpAssign,_) when List.mem AStatic l; e = expr; p2 = semicolon >] -> Some e , p2
				| [< '(Semicolon,p2) >] -> None , p2
				| [< >] -> serror()
				) in
				(FVar (name,doc,l,t,e),punion p1 p2))
		| [< '(Kwd Function,p1); name = parse_fun_name; pl = parse_constraint_params; '(POpen,_); al = psep Comma parse_fun_param; '(PClose,_); t = parse_type_opt; s >] ->
			let e = (match s with parser
				| [< e = expr >] -> e
				| [< '(Semicolon,p) >] -> (EBlock [],p)
				| [< >] -> serror()
			) in
			let f = {
				f_args = al;
				f_type = t;
				f_expr = e;
			} in
			(FFun (name,doc,l,pl,f),punion p1 (pos e))
		| [< >] ->
			if l = [] && doc = None then raise Stream.Failure else serror()

and parse_signature_field flag = parser
	| [< '(Kwd Var,p1); name = any_ident; s >] ->
		(match s with parser
		| [< '(DblDot,_); t = parse_type_path; p2 = semicolon >] -> (name,flag,AFVar t,punion p1 p2)
		| [< '(POpen,_); i1 = property_ident; '(Comma,_); i2 = property_ident; '(PClose,_); '(DblDot,_); t = parse_type_path; p2 = semicolon >] -> (name,flag,AFProp (t,i1,i2),punion p1 p2)
		| [< >] -> serror())
	| [< '(Kwd Function,p1); name = any_ident; '(POpen,_); al = psep Comma parse_fun_param_type; '(PClose,_); '(DblDot,_); t = parse_type_path; p2 = semicolon >] ->
		(name,flag,AFFun (al,t),punion p1 p2)
	| [< '(Kwd Private,_) when flag = None; s >] -> parse_signature_field (Some false) s
	| [< '(Kwd Public,_) when flag = None; s >] -> parse_signature_field (Some true) s

and parse_cf_rights allow_static l = parser
	| [< '(Kwd Static,_) when allow_static; l = parse_cf_rights false (AStatic :: l) >] -> l
	| [< '(Kwd Public,_) when not(List.mem APublic l || List.mem APrivate l); l = parse_cf_rights allow_static (APublic :: l) >] -> l
	| [< '(Kwd Private,_) when not(List.mem APublic l || List.mem APrivate l); l = parse_cf_rights allow_static (APrivate :: l) >] -> l
	| [< '(Kwd Override,_) when allow_static; l = parse_cf_rights false (AOverride :: l) >] -> l
	| [< '(Kwd F9Dynamic,_) when not (List.mem AF9Dynamic l); l = parse_cf_rights false (AF9Dynamic :: l) >] -> l
	| [< >] -> l

and parse_fun_name = parser
	| [< '(Const (Ident name),_) >] -> name
	| [< '(Const (Type name),_) >] -> name
	| [< '(Kwd New,_) >] -> "new"

and parse_fun_param = parser
	| [< '(Question,_); name = any_ident; t = parse_type_opt >] -> (name,true,t)
	| [< name = any_ident; t = parse_type_opt >] -> (name,false,t)

and parse_fun_param_type = parser
	| [< '(Question,_); name = any_ident; '(DblDot,_); t = parse_type_path >] -> (name,true,t)
	| [< name = any_ident; '(DblDot,_); t = parse_type_path >] -> (name,false,t)

and parse_constraint_params = parser
	| [< '(Binop OpLt,_); l = psep Comma parse_constraint_param; '(Binop OpGt,_) >] -> l
	| [< >] -> []

and parse_constraint_param = parser
	| [< '(Binop OpAdd,_); '(Const (Type name),_); s >] -> parse_constraint_param_next VCo name s
	| [< '(Binop OpSub,_); '(Const (Type name),_); s >] -> parse_constraint_param_next VContra name s
	| [< '(Binop OpMult,_); '(Const (Type name),_); s >] -> parse_constraint_param_next VBi name s
	| [< '(Const (Type name),_); s >] -> parse_constraint_param_next VNo name s

and parse_constraint_param_next v name = parser
	| [< '(DblDot,_); s >] ->
		(match s with parser
		| [< '(POpen,_); l = psep Comma parse_type_path_normal; '(PClose,_) >] -> (v,name,l)
		| [< t = parse_type_path_normal >] -> (v,name,[t])
		| [< >] -> serror())
	| [< >] -> (v,name,[])

and parse_class_herit = parser
	| [< '(Kwd Extends,_); t = parse_type_path_normal >] -> HExtends t
	| [< '(Kwd Implements,_); t = parse_type_path_normal >] -> HImplements t

and block1 = parser
	| [< '(Const (Ident name),p); s >] -> block2 name true p s
	| [< '(Const (Type name),p); s >] -> block2 name false p s
	| [< b = block >] -> EBlock b

and block2 name ident p = parser
	| [< '(DblDot,_); e = expr; l = parse_obj_decl >] -> EObjectDecl ((name,e) :: l)
	| [< e = expr_next (EConst (if ident then Ident name else Type name),p); s >] ->
		try
			let _ = semicolon s in
			let b = block s in
			EBlock (e :: b)
		with
			| Error (e,p) ->
				(!display_error) e p;
				EBlock (block s)

and block s =
	try
		let e = parse_block_elt s in
		e :: block s
	with
		| Stream.Failure ->
			[]
		| Stream.Error _ ->
			let tk , pos = (match Stream.peek s with None -> last_token s | Some t -> t) in
			(!display_error) (Unexpected tk) pos;
			block s
        | Error (e,p) ->
			(!display_error) e p;
			block s

and parse_block_elt = parser
	| [< '(Kwd Var,p1); vl = psep Comma parse_var_decl; p2 = semicolon >] -> (EVars vl,punion p1 p2)
	| [< e = expr; _ = semicolon >] -> e

and parse_obj_decl = parser
	| [< '(Comma,_); s >] ->
		(match s with parser
		| [< name = any_ident; '(DblDot,_); e = expr; l = parse_obj_decl >] -> (name,e) :: l
		| [< >] -> [])
	| [< >] -> []

and parse_array_decl = parser
	| [< e = expr; s >] ->
		(match s with parser
		| [< '(Comma,_); l = parse_array_decl >] -> e :: l
		| [< >] -> [e])
	| [< >] ->
		[]

and parse_var_decl = parser
	| [< name = any_ident; t = parse_type_opt; s >] ->
		match s with parser
		| [< '(Binop OpAssign,_); e = expr >] -> (name,t,Some e)
		| [< >] -> (name,t,None)

and expr = parser
	| [< '(BrOpen,p1); b = block1; '(BrClose,p2); s >] -> 
		let e = (b,punion p1 p2) in
		(match b with
		| EObjectDecl _ -> expr_next e s
		| _ -> e)
	| [< '(Const c,p); s >] -> expr_next (EConst c,p) s
	| [< '(Kwd This,p); s >] -> expr_next (EConst (Ident "this"),p) s
	| [< '(Kwd Callback,p); s >] -> expr_next (EConst (Ident "callback"),p) s
	| [< '(Kwd Cast,p1); s >] ->
		(match s with parser
		| [< '(POpen,_); e = expr; s >] ->
			(match s with parser
			| [< '(Comma,_); t = parse_type_path; '(PClose,p2); s >] -> expr_next (ECast (e,Some t),punion p1 p2) s
			| [< '(PClose,p2); s >] -> expr_next (ECast (e,None),punion p1 (pos e)) s
			| [< >] -> serror())
		| [< e = expr; s >] -> expr_next (ECast (e,None),punion p1 (pos e)) s
		| [< >] -> serror())
	| [< '(Kwd Throw,p); e = expr >] -> (EThrow e,p)
	| [< '(Kwd New,p1); t = parse_type_path_normal; '(POpen,_); al = psep Comma expr; '(PClose,p2); s >] -> expr_next (ENew (t,al),punion p1 p2) s
	| [< '(POpen,p1); e = expr; '(PClose,p2); s >] -> expr_next (EParenthesis e, punion p1 p2) s
	| [< '(BkOpen,p1); l = parse_array_decl; '(BkClose,p2); s >] -> expr_next (EArrayDecl l, punion p1 p2) s
	| [< '(Kwd Function,p1); '(POpen,_); al = psep Comma parse_fun_param; '(PClose,_); t = parse_type_opt; e = expr; s >] ->
		let f = {
			f_type = t;
			f_args = al;
			f_expr = e;
		} in
		expr_next (EFunction f, punion p1 (pos e)) s
	| [< '(Unop op,p1) when is_prefix op; e = expr >] -> make_unop op e p1
	| [< '(Binop OpSub,p1); e = expr >] -> make_unop Neg e p1
	| [< '(Kwd For,p); '(POpen,_); name = any_ident; '(Kwd In,_); it = expr; '(PClose,_); e = expr; s >] ->
		expr_next (EFor (name,it,e),punion p (pos e)) s
	| [< '(Kwd If,p); '(POpen,_); cond = expr; '(PClose,_); e1 = expr; s >] ->
		let e2 , s = (match s with parser
			| [< '(Kwd Else,_); e2 = expr; s >] -> Some e2 , s
			| [< >] ->
				match Stream.npeek 2 s with
				| [(Semicolon,_);(Kwd Else,_)] ->
					Stream.junk s;
					Stream.junk s;
					(match s with parser
					| [< e2 = expr; s >] -> Some e2, s
					| [< >] -> serror())
				| _ ->
					None , s
		) in
		expr_next (EIf (cond,e1,e2), punion p (match e2 with None -> pos e1 | Some e -> pos e)) s
	| [< '(Kwd Return,p); e = popt expr >] -> (EReturn e, match e with None -> p | Some e -> punion p (pos e))
	| [< '(Kwd Break,p) >] -> (EBreak,p)
	| [< '(Kwd Continue,p) >] -> (EContinue,p)
	| [< '(Kwd While,p1); '(POpen,_); cond = expr; '(PClose,_); e = expr; s >] -> expr_next (EWhile (cond,e,NormalWhile),punion p1 (pos e)) s
	| [< '(Kwd Do,p1); e = expr; '(Kwd While,_); '(POpen,_); cond = expr; '(PClose,_); s >] -> expr_next (EWhile (cond,e,DoWhile),punion p1 (pos e)) s
	| [< '(Kwd Switch,p1); e = expr; '(BrOpen,_); cases , def = parse_switch_cases; '(BrClose,p2); s >] -> expr_next (ESwitch (e,cases,def),punion p1 p2) s
	| [< '(Kwd Try,p1); e = expr; cl = plist parse_catch; s >] -> expr_next (ETry (e,cl),p1) s
	| [< '(IntInterval i,p1); e2 = expr >] -> make_binop OpInterval (EConst (Int i),p1) e2
	| [< '(Kwd Untyped,p1); e = expr >] -> (EUntyped e,punion p1 (pos e))

and expr_next e1 = parser
	| [< '(Dot,_); s >] ->
		(match s with parser
		| [< '(Const (Ident f),p); s >] -> expr_next (EField (e1,f) , punion (pos e1) p) s
		| [< '(Const (Type t),p); s >] -> expr_next (EType (e1,t) , punion (pos e1) p) s
		| [< >] -> serror())
	| [< '(POpen,p1); params = psep Comma expr; '(PClose,p2); s >] ->
		expr_next (ECall (e1,params) , punion (pos e1) p2) s
	| [< '(BkOpen,_); e2 = expr; '(BkClose,p2); s >] ->
		expr_next (EArray (e1,e2), punion (pos e1) p2) s
	| [< '(Binop OpGt,_); s >] ->
		(match s with parser
		| [< '(Binop OpGt,_); s >] ->
			(match s with parser
			| [< '(Binop OpGt,_) >] ->
				(match s with parser
				| [< '(Binop OpAssign,_); e2 = expr >] -> make_binop (OpAssignOp OpUShr) e1 e2
				| [< e2 = expr >] -> make_binop OpUShr e1 e2
				| [< >] -> serror())
			| [< '(Binop OpAssign,_); e2 = expr >] -> make_binop (OpAssignOp OpShr) e1 e2
			| [< e2 = expr >] -> make_binop OpShr e1 e2
			| [< >] -> serror())
		| [< '(Binop OpAssign,_); s >] ->
			(match s with parser
			| [< e2 = expr >] -> make_binop OpGte e1 e2
			| [< >] -> serror())
		| [< e2 = expr >] ->
			make_binop OpGt e1 e2
		| [< >] -> serror())
	| [< '(Binop op,_); e2 = expr >] ->
		make_binop op e1 e2
	| [< '(Unop op,p) when is_postfix e1 op; s >] ->
		expr_next (EUnop (op,Postfix,e1), punion (pos e1) p) s
	| [< >] -> e1

and parse_switch_cases = parser
	| [< '(Kwd Default,p1); '(DblDot,_); e = block1; l , def = parse_switch_cases >] ->
		(match def with None -> () | Some (e,p) -> error Duplicate_default p);
		l , Some (e , p1)
	| [< '(Kwd Case,p1); el = psep Comma expr; '(DblDot,_); b = block1; l , def = parse_switch_cases >] ->
		(el,(b,p1)) :: l , def
	| [< >] ->
		[] , None

and parse_catch = parser
	| [< '(Kwd Catch,_); '(POpen,_); name = any_ident; s >] ->
		match s with parser
		| [< '(DblDot,_); t = parse_type_path; '(PClose,_); e = expr >] -> (name,t,e)
		| [< '(_,p) >] -> error Missing_type p

let parse code file =
	let old = Lexer.save() in
	let old_cache = !cache in
	let mstack = ref [] in
	cache := DynArray.create();
	doc := None;
	Lexer.init file;
	let rec next_token() = process_token (Lexer.token code)

	and process_token tk =
		match fst tk with
		| Comment s ->
			let l = String.length s in
			if l > 2 && s.[0] = '*' && s.[l-1] = '*' then doc := Some (String.sub s 1 (l-2));
			next_token()
		| CommentLine s ->
			next_token()
		| Macro "end" ->
			(match !mstack with
			| [] -> raise Exit
			| _ :: l ->
				mstack := l;
				next_token())
		| Macro "else" ->
			(match !mstack with
			| [] -> raise Exit
			| _ :: l ->
				mstack := l;
				process_token (skip_tokens false))
		| Macro "if" ->
			process_token (enter_macro())
		| _ ->
			tk

	and enter_macro() =
		let ok , tk = eval_macro false in
		if ok then begin
			mstack := snd tk :: !mstack;
			tk
		end else
			skip_tokens_loop true tk

	and eval_macro allow_expr =
		match Lexer.token code with
		| (Const (Ident s),p) | (Const (Type s),p) ->
			if s = "error" then error Unimplemented p;
			let ok = Plugin.defined s in
			(match Lexer.token code with
			| (Binop OpBoolOr,_) when allow_expr ->
				let ok2 , tk = eval_macro allow_expr in
				(ok || ok2) , tk
			| (Binop OpBoolAnd,_) when allow_expr ->
				let ok2 , tk = eval_macro allow_expr in
				(ok && ok2) , tk
			| tk ->
				ok , tk)
		| (Unop Not,_) ->
			let ok , tk = eval_macro allow_expr in
			not ok, tk
		| (POpen,_) ->
			let ok , tk = eval_macro true in
			(match tk with
			| (PClose,_) -> ok, Lexer.token code
			| _ -> raise Exit)
		| _ ->
			raise Exit

	and skip_tokens_loop test tk =
		match fst tk with
		| Macro "end" ->
			Lexer.token code
		| Macro "else" when not test ->
			skip_tokens test
		| Macro "else" ->
			enter_macro()
		| Macro "if" ->
			skip_tokens_loop test (skip_tokens false)
		| Eof ->
			raise Exit
		| _ ->
			skip_tokens test

	and skip_tokens test = skip_tokens_loop test (Lexer.token code)

	in
	let s = Stream.from (fun _ ->
		try
			let t = next_token() in
			DynArray.add (!cache) t;
			Some t
		with
			Exit -> None
	) in
	try
		let l = parse_file s in
		(match !mstack with [] -> () | p :: _ -> error Unclosed_macro p);
		cache := old_cache;
		Lexer.restore old;
		l
	with
		| Stream.Error _
		| Stream.Failure ->
			let last = (match Stream.peek s with None -> last_token s | Some t -> t) in
			Lexer.restore old;
			cache := old_cache;
			error (Unexpected (fst last)) (pos last)
		| e ->
			Lexer.restore old;
			cache := old_cache;
			raise e
