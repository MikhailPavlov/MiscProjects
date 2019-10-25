/*
VERSION: 1.0
DATE: 1/8/2009
ACTIONSCRIPT VERSION: 2.0 (AS3 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
DESCRIPTION:
	Performs SLERP interpolation between 2 Quaternions. Each Quaternion should have x, y, z, and w properties.
	Simply pass in an Object containing properties that correspond to your object's quaternion properties. 
	For example, if your myCamera3D has an "orientation" property that's a Quaternion and you want to 
	tween its values to x:1, y:0.5, z:0.25, w:0.5, you could do:
	
		TweenLite.to(myCamera3D, 2, {quaternions:{orientation:new Quaternion(1, 0.5, 0.25, 0.5)}});
		
	You can define as many quaternion properties as you want.
	
USAGE:
	import gs.*;
	import gs.plugins.*;
	TweenPlugin.activate([QuaternionsPlugin]); //only do this once in your SWF to activate the plugin
	
	TweenLite.to(myCamera3D, 2, {quaternions:{orientation:new Quaternion(1, 0.5, 0.25, 0.5)}});
	
	
BYTES ADDED TO SWF: 743 (not including dependencies)

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/
import gs.*;
import gs.plugins.*;

class gs.plugins.QuaternionsPlugin extends TweenPlugin {
		public static var VERSION:Number = 1.0;
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		private static var _RAD2DEG:Number = 180 / Math.PI; //precalculate for speed
		
		private var _target:Object;
		private var _quaternions:Array = [];
		
		public function QuaternionsPlugin() {
			super();
			this.propName = "quaternions"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = [];
		}
		
		public function onInitTween($target:Object, $value:Object, $tween:TweenLite):Boolean {
			if ($value == undefined) {
				return false;
			}
			for (var p:String in $value) {
				initQuaternion($target[p], $value[p], p);
			}
			return true;	
		}
		
		public function initQuaternion($start:Object, $end:Object, $propName:String):Void {
			var angle:Number, q1:Object, q2:Object, x1:Number, x2:Number, y1:Number, y2:Number, z1:Number, z2:Number, w1:Number, w2:Number, theta:Number;
			q1 = $start;
			q2 = $end;
			x1 = q1.x; x2 = q2.x;
			y1 = q1.y; y2 = q2.y;
			z1 = q1.z; z2 = q2.z;
			w1 = q1.w; w2 = q2.w;
			angle = x1 * x2 + y1 * y2 + z1 * z2 + w1 * w2;
			if (angle < 0) {
				x1 *= -1;
				y1 *= -1;
				z1 *= -1;
				w1 *= -1;
				angle *= -1;
			}
			if ((angle + 1) < 0.000001) {
				y2 = -y1;
				x2 = x1;
				w2 = -w1;
				z2 = z1;
			}
			theta = Math.acos(angle);
			_quaternions[_quaternions.length] = [q1, $propName, x1, x2, y1, y2, z1, z2, w1, w2, angle, theta, 1 / Math.sin(theta)];
			this.overwriteProps[this.overwriteProps.length] = $propName;
		}
		
		public function killProps($lookup:Object):Void {
			for (var i:Number = _quaternions.length - 1; i > -1; i--) {
				if ($lookup[_quaternions[i][1]] != undefined) {
					_quaternions.splice(i, 1);
				}
			}
			super.killProps($lookup);
		}	
		
		public function set changeFactor($n:Number):Void {
			var i:Number, q:Array, scale:Number, invScale:Number;
			for (i = _quaternions.length - 1; i > -1; i--) {
				q = _quaternions[i];
				if ((q[10] + 1) > 0.000001) {
					 if ((1 - q[10]) >= 0.000001) {
						scale = Math.sin(q[11] * (1 - $n)) * q[12];
						invScale = Math.sin(q[11] * $n) * q[12];
					 } else {
						scale = 1 - $n;
						invScale = $n;
					 }
				} else {
					scale = Math.sin(Math.PI * (0.5 - $n));
					invScale = Math.sin(Math.PI * $n);
				}
				q[0].x = scale * q[2] + invScale * q[3];
				q[0].y = scale * q[4] + invScale * q[5];
				q[0].z = scale * q[6] + invScale * q[7];
				q[0].w = scale * q[8] + invScale * q[9];
			}
			/*
			Array access is faster (though less readable). Here is the key:
			0 - target
			1 = propName
			2 = x1
			3 = x2
			4 = y1
			5 = y2
			6 = z1
			7 = z2
			8 = w1
			9 = w2
			10 = angle
			11 = theta
			12 = invTheta
			*/
		}
	
}