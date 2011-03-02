package js;

typedef JqEvent = {
	var target : Dom.HtmlDom;
	var currentTarget : Dom.HtmlDom;
	var relatedTarget : Dom.HtmlDom;

	var type : String;
	var timeStamp : Int;

	//var data : Dynamic;
	//var namespace : String;
	//var result : Dynamic;

	// position
	var pageX : Int;
	var pageY : Int;

	// keys
	var which : Int;

	// propagation
	function isDefaultPrevented() : Bool;
	function isImmediatePropagationStopped() : Bool;
	function isPropationStopped() : Bool;
	function preventDefault() : Void;
	function stopImmediatePropagation() : Void;
	function stopPropagation() : Void;
}

extern class JQuery implements ArrayAccess<JQuery> {

	var context(default,null) : Dom.HtmlDom;
	var length(default, null) : Int;

	function new( queryOrHtml : String, ?context : JQuery ) : Void;

	// attributes
	function addClass( className : String ) : JQuery;
	function removeClass( className : String ) : JQuery;
	function hasClass( className : String ) : Bool;
	function toggleClass( className : String, ?addRemove : Bool ) : JQuery;

	function attr( name : String, ?value : String ) : String;
	function removeAttr( attr : String ) : JQuery;

	function css( prop : String, ?value : String ) : String;
	function html( ?fill : String ) : String; // first element only
	function val( ?value : String ) : String; // for input elements
	function text( ?value : String ) : String;

	// Size & Position
	function width( ?value : Int ) : Int;
	function height( ?value : Int ) : Int;
	function innerWidth( ?value : Int ) : Int;
	function innerHeight( ?value : Int ) : Int;
	function outerWidth( ?includeMargin : Bool ) : Int;
	function outerHeight( ?includeMargin : Bool ) : Int;
	function scrollLeft( ?value : Int ) : Int;
	function scrollTop( ?value : Int ) : Int;
	function offset( ?value : { left : Int, top : Int } ) : { left : Int, top : Int };
	function offsetParent() : JQuery;
	function position( ?value : { left : Int, top : Int } ) : { left : Int, top : Int };

	// current group manipulation
	function add( selectorOrHTML : String, ?context : JQuery ) : JQuery;
	function andSelf() : JQuery;
	function children( ?selector : String ) : JQuery;
	function clone( ?withDataAndEvents : Bool ) : JQuery;
	function closest( selector : String, ?context : JQuery ) : JQuery;
	function contents() : JQuery;
	function each( f : Void -> Void ) : JQuery;
	function end() : JQuery;
	function eq( index : Int ) : JQuery;
	function filter( selector : String ) : JQuery;
	function find( selector : String ) : JQuery;
	function first() : JQuery;
	function index( ?selector : String ) : Int;
	function last( ?selector : String ) : JQuery;
	function has( selector : String ) : JQuery;
	function next( ?selector : String ) : JQuery;
	function nextAll( ?selector : String ) : JQuery;
	function nextUntil( ?selector : String ) : JQuery;
	function parent( ?selector : String ) : JQuery;
	function parents( ?selector : String ) : JQuery;
	function parentsUntil( ?selector : String ) : JQuery;
	function not( selector : String ) : JQuery;
	function prev( ?selector : String ) : JQuery;
	function prevAll( ?selector : String ) : JQuery;
	function prevUntil( ?selector : String ) : JQuery;
	function pushStack( elements : Array<Dom.HtmlDom> ) : JQuery;
	function siblings( ?selector : String ) : JQuery;
	function size() : Int;
	function slice( start : Int, ?end : Int ) : JQuery;
	function toArray() : Array<Dom.HtmlDom>;

	// DOM changes
	@:multitype function before( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function after( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function append( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function appendTo( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	function detach( ?selector : String ) : JQuery;
	function empty() : JQuery; // remove all texts
	@:multitype function insertBefore( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function insertAfter( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function prepend( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function prependTo( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	function remove( ?selector : String ) : JQuery;
	function replaceAll( selector : String ) : JQuery;
	@:multitype function replaceWith( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	function unwrap() : JQuery;
	@:multitype function wrap( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function wrapAll( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;
	@:multitype function wrapInner( ?html : String, ?j : JQuery, ?h : Dom.HtmlDom ) : JQuery;

	// animation
	function animate( properties : { }, ?duration : Int, ?callb : Void -> Void ) : JQuery;
	function delay( duration : Int, ?queueName : String ) : JQuery;
	function hide( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function fadeIn( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function fadeOut( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function fadeTo( duration : Int, opacity : Float, ?call : Void -> Void ) : JQuery;
	function fadeToggle( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function show( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function sliceDown( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function sliceToggle( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function sliceUp( ?duration : Int, ?call : Void -> Void ) : JQuery;
	function stop( ?clearQueue : Bool, ?jumpToEnd : Bool ) : JQuery;
	function toggle( ?duration : Int, ?call : Void -> Void ) : JQuery;

	// Events
	function blur( ?callb : JqEvent -> Void ) : JQuery;
	function change( ?callb : JqEvent -> Void ) : JQuery;
	function click( ?callb : JqEvent -> Void ) : JQuery;
	function dblclick( ?callb : JqEvent -> Void ) : JQuery;
	function error( ?callb : JqEvent -> Void ) : JQuery;
	function focus( ?callb : JqEvent -> Void ) : JQuery;
	function focusin( ?callb : JqEvent -> Void ) : JQuery;
	function focusout( ?callb : JqEvent -> Void ) : JQuery;
	function hover( onOver : JqEvent -> Void, ?onOut : Void -> Void ) : JQuery;
	function keydown( ?callb : JqEvent -> Void ) : JQuery;
	function keypress( ?callb : JqEvent -> Void ) : JQuery;
	function keyup( ?callb : JqEvent -> Void ) : JQuery;
	function mousedown( ?callb : JqEvent -> Void ) : JQuery;
	function mouseenter( ?callb : JqEvent -> Void ) : JQuery;
	function mouseleave( ?callb : JqEvent -> Void ) : JQuery;
	function mouseout( ?callb : JqEvent -> Void ) : JQuery;
	function mouseover( ?callb : JqEvent -> Void ) : JQuery;
	function mouseup( ?callb : JqEvent -> Void ) : JQuery;
	function load( ?callb : JqEvent -> Void ) : JQuery;
	function ready( callb : JqEvent -> Void ) : JQuery;
	function resize( ?callb : JqEvent -> Void ) : JQuery;
	function scroll( ?callb : JqEvent -> Void ) : JQuery;
	function select( ?callb : JqEvent -> Void ) : JQuery;
	function submit( ?callb : JqEvent -> Void ) : JQuery;
	function unload( ?callb : JqEvent -> Void ) : JQuery;

	function bind( events : String, callb : JqEvent -> Void ) : JQuery;
	function delegate( selector : String, events : String, callb : JqEvent -> Void ) : JQuery;
	function die( ?events : String, ?callb : JqEvent -> Void ) : JQuery;
	function one( events : String, callb : JqEvent -> Void ) : JQuery;
	function live( events : String, callb : JqEvent -> Void ) : JQuery;
	function trigger( events : String ) : JQuery;
	function triggerHandler( events : String ) : JQuery;
	function unbind( ?events : String, ?callb : JqEvent -> Void ) : JQuery;
	function undelegate( ?selector : String, ?events : String, ?callb : JqEvent -> Void ) : JQuery;

	// queue
	function clearQueue( ?queueName : String ) : JQuery;
	function dequeue( ?queueName : String ) : JQuery;
	function queue( ?queueName : String ) : { length : Int };

	// ajax
	// TODO

	// deferred
	// TODO

	// other tools
	function get() : Array<Dom.HtmlDom>;
	function is( selector : String ) : Bool;
	function data<T>( key : String, ?value : T ) : T;
	function removeData( ?key : String ) : JQuery;
	function serialize() : String;
	function serializeArray() : Array<{ name : String, value : String }>;
	//inline function map<T>( f : JQuery -> T ) : Array<T> {
	//	return untyped this["map"](function() return f(cur)).get();
	//}


	// haxe-additions
	inline function noBubble( events : String ) : JQuery { return (cast this).bind(events, false); }
	inline function loadURL( url : String, ?callb : Void -> Void ) : JQuery { return (cast this).load(url,callb); }
	inline function toggleClick( ?first : Void -> Void, ?second : Void -> Void ) : JQuery { return (cast this).toggle(first, second); }

	inline static function of( d : Dom.HtmlDom ) : JQuery { return new js.JQuery(cast d); }

	/**
		Return the current JQuery element (in a callback), similar to $(this) in JS.
	**/
	static var cur(getCurrent, null) : JQuery;

	static var fx(default, null) : { off : Bool, interval : Int };
	static var browser(default, null) : { webkit : Bool, opera : Bool, msie : Bool, mozilla : Bool, version : String };

	static function contains( parent : Dom.HtmlDom, child : Dom.HtmlDom ) : Bool;
	static function noConflict( ?removeAll : Bool ) : Void;
	static function parseJSON( json : String ) : Dynamic;


	//static function parseXML
	//static function get, post
	//static function getJSON, getScript, globalEval, grep
	//static function is*, makeArray, map, merge, noop, now, param, proxy, sub, trim, type, unique

	private static inline function getCurrent() : JQuery {
		return untyped __js__("$(this)");
	}

	private static function __init__() : Void untyped {
		#if !noEmbedJS
		haxe.macro.Tools.includeFile("js/jquery-1.5.min.js");
		#end
		var q : Dynamic = window.jQuery;
		js.JQuery = q;
		q.fn.noBubble = q.fn.bind;
		q.fn.loadURL = q.fn.load;
		q.fn.toggleClick = q.fn.toggle;
		q.of = q;
	}
}