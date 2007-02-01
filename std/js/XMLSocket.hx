/*
 * Copyright (c) 2005-2007, The haXe Project Contributors
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
package js;

/**
	By compiling the [flash.SocketWrapper] into a SWF, you can create and use XMLSockets directly from Javascript.
**/
class XMLSocket {

	static var sockets = Reflect.empty();
	static var ID = 0;

	var id : String;
	var rcnx : haxe.remoting.Connection;
	var cnx : haxe.remoting.Connection;

	public function new( flashObject : String ) {
		id = "s"+(ID++);
		rcnx = haxe.remoting.Connection.flashConnect(flashObject).haxe.remoting.SocketWrapper;
		rcnx.create.call([id]);
		var cnx : { private function __resolve( id : String ) : haxe.remoting.Connection; } = rcnx.sockets;
		this.cnx = cnx.__resolve(Std.string(id));
		Reflect.setField(sockets,id,this);
	}

	public function destroy() {
		rcnx.destroy.call([id]);
		Reflect.deleteField(sockets,id);
	}

	public function connect( host : String, port : Int ) {
		cnx.connect.call([host,port]);
	}

	public function send( data : String ) {
		cnx.send.call([data]);
	}

	public function close() {
		cnx.close.call([]);
	}

	public function onData( data : String ) {
	}

	public function onClose() {
	}

	public function onConnect( b : Bool ) {
	}

}