/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package haxe;

// std
import Array;
import Class;
import Date;
import DateTools;
import EReg;
import Hash;
import IntHash;
import IntIter;
import Lambda;
import List;
import Math;
import Reflect;
import Std;
import StdTypes;
import String;
import StringBuf;
import StringTools;
import Type;
import Xml;

import haxe.FastList;
#if !neko
import haxe.Firebug;
#end
import haxe.Http;
import haxe.ImportAll;
import haxe.Log;
import haxe.Md5;
import haxe.PosInfos;
import haxe.Serializer;
import haxe.Stack;
import haxe.Template;
import haxe.Timer;
import haxe.Unserializer;
import haxe.Int32;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import haxe.io.Error;
import haxe.io.Input;
import haxe.io.Output;
import haxe.io.StringInput;

import haxe.remoting.Connection;
import haxe.remoting.AsyncConnection;
import haxe.remoting.ExternalConnection;
import haxe.remoting.HttpConnection;
import haxe.remoting.HttpAsyncConnection;
import haxe.remoting.AMFConnection;
import haxe.remoting.AsyncAdapter;
import haxe.remoting.AsyncDebugConnection;
import haxe.remoting.Proxy;
import haxe.remoting.AsyncProxy;
import haxe.remoting.LocalConnection;
import haxe.remoting.DelayedConnection;
import haxe.remoting.FlashJsConnection;
#if neko
import haxe.remoting.NekoSocketConnection;
#else
import haxe.remoting.SocketConnection;
#end
import haxe.remoting.SocketProtocol;
#if flash
import haxe.remoting.SocketWrapper;
#end

import haxe.rtti.Infos;
import haxe.rtti.Type;
import haxe.rtti.XmlParser;
import haxe.rtti.Generic;

import haxe.xml.Check;
import haxe.xml.Fast;
import haxe.xml.Proxy;

import haxe.unit.TestCase;
import haxe.unit.TestResult;
import haxe.unit.TestRunner;
import haxe.unit.TestStatus;

#if flash9

// generated by haxe
import flash.Boot;
import flash.Lib;
import flash.FlashXml__;
import flash.accessibility.Accessibility;
import flash.accessibility.AccessibilityImplementation;
import flash.accessibility.AccessibilityProperties;
import flash.display.ActionScriptVersion;
import flash.display.AVM1Movie;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.BlendMode;
import flash.display.CapsStyle;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.FrameLabel;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.InteractiveObject;
import flash.display.InterpolationMethod;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MorphShape;
import flash.display.MovieClip;
import flash.display.PixelSnapping;
import flash.display.Scene;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.display.SWFVersion;
import flash.events.ActivityEvent;
import flash.events.AsyncErrorEvent;
import flash.events.ContextMenuEvent;
import flash.events.DataEvent;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.EventPhase;
import flash.events.FocusEvent;
import flash.events.FullScreenEvent;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IMEEvent;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.NetFilterEvent;
import flash.events.NetStatusEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.events.SyncEvent;
import flash.events.TextEvent;
import flash.events.TimerEvent;
import flash.events.WeakFunctionClosure;
import flash.events.WeakMethodClosure;
import flash.external.ExternalInterface;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.BitmapFilterType;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.ConvolutionFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.DisplacementMapFilterMode;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.filters.GradientBevelFilter;
import flash.filters.GradientGlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;
import flash.media.Camera;
import flash.media.ID3Info;
import flash.media.Microphone;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.DynamicPropertyOutput;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.net.IDynamicPropertyOutput;
import flash.net.IDynamicPropertyWriter;
import flash.net.LocalConnection;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.net.ObjectEncoding;
import flash.net.Responder;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
import flash.net.Socket;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLStream;
import flash.net.URLVariables;
import flash.net.XMLSocket;
import flash.printing.PrintJob;
import flash.printing.PrintJobOptions;
import flash.printing.PrintJobOrientation;
import flash.system.ApplicationDomain;
import flash.system.Capabilities;
import flash.system.FSCommand;
import flash.system.IME;
import flash.system.IMEConversionMode;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;
import flash.system.SecurityPanel;
import flash.system.System;
import flash.text.AntiAliasType;
import flash.text.CSMSettings;
import flash.text.Font;
import flash.text.FontStyle;
import flash.text.FontType;
import flash.text.GridFitType;
import flash.text.StaticText;
import flash.text.StyleSheet;
import flash.text.TextColorType;
import flash.text.TextDisplayMode;
import flash.text.TextExtent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFormatDisplay;
import flash.text.TextLineMetrics;
import flash.text.TextRenderer;
import flash.text.TextRun;
import flash.text.TextSnapshot;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuBuiltInItems;
import flash.ui.ContextMenuItem;
import flash.ui.Keyboard;
import flash.ui.KeyLocation;
import flash.ui.Mouse;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Endian;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.IExternalizable;
import flash.utils.ObjectInput;
import flash.utils.ObjectOutput;
import flash.utils.Proxy;
import flash.utils.SetIntervalTimer;
import flash.utils.Timer;
import flash.utils.TypedDictionary;
import flash.utils.QName;
import flash.utils.Namespace;
import flash.xml.XML;
import flash.xml.XMLList;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.xml.XMLNodeType;
import flash.xml.XMLParser;
import flash.xml.XMLTag;
import flash.trace.Trace;
import flash.sampler.Api;
import flash.sampler.DeleteObjectSample;
import flash.sampler.NewObjectSample;
import flash.sampler.Sample;
import flash.sampler.StackFrame;

#elseif flash

import flash.Boot;
import flash.Lib;

import flash.Accessibility;
import flash.Button;
import flash.Camera;
import flash.Color;
import flash.ContextMenu;
import flash.ContextMenuItem;
#if flash_lite
import flash.ExtendedKey;
#end
import flash.Key;
import flash.LoadVars;
import flash.LocalConnection;
import flash.Microphone;
import flash.Mouse;
import flash.MovieClip;
import flash.MovieClipLoader;
import flash.NetConnection;
import flash.NetStream;
import flash.PrintJob;
import flash.Selection;
import flash.SharedObject;
import flash.Sound;
import flash.Stage;
import flash.System;
import flash.TextField;
import flash.TextFormat;
import flash.TextSnapshot;
import flash.Video;
import flash.XMLRequest;
import flash.XMLSocket;

import flash.text.StyleSheet;
import flash.system.Capabilities;
import flash.system.Security;

#end

#if flash8

import flash.display.BitmapData;
import flash.external.ExternalInterface;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.ConvolutionFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.filters.GradientBevelFilter;
import flash.filters.GradientGlowFilter;

import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;

import flash.net.FileReference;
import flash.net.FileReferenceList;

import flash.system.IME;
import flash.text.TextRenderer;

#end

#if neko

import neko.Boot;
import neko.FileSystem;
import neko.Lib;
import neko.Random;
import neko.Sys;
import neko.Utf8;
import neko.Web;

import neko.io.File;
import neko.io.FileInput;
import neko.io.FileOutput;
import neko.io.Path;
import neko.io.Process;

import neko.zip.Compress;
import neko.zip.CRC32;
import neko.zip.Reader;
import neko.zip.Writer;
import neko.zip.Flush;
import neko.zip.Uncompress;

import neko.db.Connection;
import neko.db.Manager;
import neko.db.Mysql;
import neko.db.Object;
import neko.db.ResultSet;
import neko.db.Sqlite;
import neko.db.Transaction;

import neko.net.Host;
import neko.net.Poll;
import neko.net.ProxyDetect;
import neko.net.ServerLoop;
import neko.net.Socket;
import neko.net.SocketInput;
import neko.net.SocketOutput;
import neko.net.ThreadRemotingServer;
import neko.net.ThreadServer;

import neko.vm.Loader;
import neko.vm.Module;
import neko.vm.Thread;
import neko.vm.Tls;
import neko.vm.Lock;
import neko.vm.Ui;
import neko.vm.Gc;

#end

#if js

import js.Boot;
import js.Lib;
import js.Dom;
import js.Selection;
import js.SWFObject;
import js.XMLHttpRequest;
import js.XMLSocket;

#end

// TOOLS

#if neko

import tools.haxedoc.Main;
import tools.haxelib.Main;
import tools.haxelib.Site;
//import tools.hxinst.Main -> needs xCross

#end

