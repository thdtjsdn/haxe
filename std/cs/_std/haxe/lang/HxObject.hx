package haxe.lang;private typedef StdType = Type;import system.Type;@:native('haxe.lang.HxObject')private class HxObject implements IHxObject{	}@:native('haxe.lang.IHxObject')private interface IHxObject{	}@:native('haxe.lang.DynamicObject')private class DynamicObject extends HxObject, implements Dynamic{	}@:native('haxe.lang.Class')private class Class extends HxObject{	private var classProxy:IHxObject;	public function new(cls)	{		this.classProxy = cls;	}		@:functionBody('			return classProxy.GetType();	')	public function nativeType():system.Type	{		return null;	}}@:native('haxe.lang.NativeClassWrapper')@:replaceReflectionprivate class NativeClassWrapper extends Class{	private var native:Type;		public function new(native:Type)	{		super(null);		this.native = native;	}		override public function nativeType():system.Type	{		return native;	}		@:functionBody('	System.Reflection.MemberInfo[] mis = native.GetMember(field, System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static);		System.Reflection.MemberInfo mi = null;		if (mis.Length > 0)		{			mi = mis[0];			if (mi is System.Reflection.FieldInfo)			{				return ((System.Reflection.FieldInfo) mi).GetValue(null);			} else if (mi is System.Reflection.PropertyInfo)			{				return ((System.Reflection.PropertyInfo) mi).GetValue(null, null);			} else {				return new haxe.lang.Closure(field, hash, this);			}		} else {			if (isCheck)			{				return haxe.lang.Runtime.undefined;			} else if (throwErrors) {				throw haxe.lang.HaxeException.wrap("Cannot find field \'" + field + "\' on Class \'" + native );			} else {				return null;			}		}	')	private function getField(field:String, hash:Int, isStatic:Bool, throwErrors:Bool, isCheck:Bool):Dynamic	{		return null;	}		private function getField_f(field:String, hash:Int, isStatic:Bool, throwErrors:Bool):Float	{		return cast getField(field, hash, isStatic, throwErrors, false);	}		@:functionBody('		System.Reflection.MemberInfo[] mis = native.GetMember(field, System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static);		System.Reflection.MemberInfo mi = null;		if (mis.Length > 0)		{			mi = mis[0];			if (mi is System.Reflection.FieldInfo)			{				((System.Reflection.FieldInfo) mi).SetValue(null, val);				return val;			} else if (mi is System.Reflection.PropertyInfo)			{				((System.Reflection.PropertyInfo) mi).SetValue(null, val, null);				return val;			}		}				throw haxe.lang.HaxeException.wrap("Field \'" + field + "\' doesn\'t exist or is not accessible for writing on Class " + native );	')	private function setField(field:String, hash:Int, isStatic:Bool, val:Dynamic):Dynamic	{		return null;	}		private function setField_f(field:String, hash:Int, isStatic:Bool, val:Float):Float	{		return cast setField(field, hash, isStatic, val);	}		@:functionBody('			object[] nargs = (dynArgs == null) ? new object[0] : cs.Lib.toNativeReadOnlyArray<object>(((Array<object>)dynArgs.cast<object>()), true);						System.Type[] types = new System.Type[nargs.Length];            for (int i = 0; i < nargs.Length; i++)                types[i] = nargs[i].GetType();							System.Reflection.MethodInfo mi = native.GetMethod(field, System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic, null, types, new System.Reflection.ParameterModifier[0]);			if (mi == null)			{				throw haxe.lang.HaxeException.wrap("Method \'" + field + "\' not found from type " + native + " or incompatible type arguments");			}						return mi.Invoke(null, nargs);	')	private function invokeField(field:String, hash:Int, isStatic:Bool, dynArgs:Array<Dynamic>):Dynamic	{		return null;	}		@:functionBody('			System.Reflection.MemberInfo[] members = native.GetMembers(System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic);			string last = null;			for (int i = 0; i < members.Length; i++)            {				if (members[i].Name != last)					baseArr.push(last = members[i].Name);            }	')	private function classFields(baseArr:Array<String>):Void	{			}		@:functionBody('			if (isInstanceFields)			{				System.Reflection.MemberInfo[] members = native.GetMembers(System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);								string last = null;				for (int i = 0; i < members.Length; i++)				{					if (members[i].Name != last)						baseArr.push(last = members[i].Name);				}			} else {				this.classFields(baseArr);			}	')	private function getFields(baseArr:Array<String>, isInstanceFields:Bool):Void	{			}		@:functionBody('			object[] nargs = (args == null) ? new object[0] : cs.Lib.toNativeReadOnlyArray<object>(((Array<object>)args.cast<object>()), true);						System.Type[] types = new System.Type[nargs.Length];            for (int i = 0; i < nargs.Length; i++)                types[i] = nargs[i].GetType();						System.Reflection.ConstructorInfo c = native.GetConstructor(types);            return c.Invoke(nargs);	')	private function create(args:Array<Dynamic>):Dynamic	{		return null;	}		@:functionBody('			System.Type[] empty = new System.Type[0];			System.Reflection.ConstructorInfo c = native.GetConstructor(empty);			if (c == null)				throw new haxe.lang.HaxeException("Cannot apply createEmpty for native type " + native);			return c.Invoke(new object[0]);	')	private function createEmpty():Dynamic	{		return null;	}		private function getClass():Class	{		//class wrappers are always null for getClass		return null;	}		private static function getClassStatic()	{		return null;	}		}@:native('haxe.lang.Enum')@:skip_ctorprivate class Enum{	@:readonly private var index:Int;	@:readonly private var params:Array<{}>;		public function new(index:Int, params:Array<{}>)	{		this.index = index;		this.params = params;	}		@:final public function getTag():String	{		var cl:Dynamic = StdType.getClass(this);		return cl.constructs[index];	}		public function equals(obj:Dynamic)	{		if (obj == this) //we cannot use == as .Equals !			return true;				var obj:Enum = cast obj;		var ret = obj != null && Std.is(obj, StdType.getClass(this)) && obj.index == this.index;		if (!ret) 			return false;		if (obj.params == this.params)			return true;		var len = 0;		if (obj.params == null || this.params == null || (len = this.params.length) != obj.params.length)			return false;				for (i in 0...len)		{			if (obj.params[i] != this.params[i])				return false;		}		return true;	}}