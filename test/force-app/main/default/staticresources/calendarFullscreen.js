/*
@license

dhtmlxGantt v.3.3.0 Professional Evaluation
This software is covered by DHTMLX Evaluation License. Contact sales@dhtmlx.com to get Commercial or Enterprise license. Usage without proper license is prohibited.

(c) Dinamenta, UAB.
*/
Gantt.plugin(function(t){t._onFullScreenChange=function(){!t.getState().fullscreen||null!==document.fullscreenElement&&null!==document.mozFullScreenElement&&null!==document.webkitFullscreenElement&&null!==document.msFullscreenElement||t.collapse()},document.addEventListener&&(document.addEventListener("webkitfullscreenchange",t._onFullScreenChange),document.addEventListener("mozfullscreenchange",t._onFullScreenChange),document.addEventListener("MSFullscreenChange",t._onFullScreenChange),document.addEventListener("fullscreenChange",t._onFullScreenChange),
document.addEventListener("fullscreenchange",t._onFullScreenChange)),t.expand=function(){if(t.callEvent("onBeforeExpand",[])){t._toggleFullScreen(!0);var e=t._obj;do e._position=e.style.position||"",e.style.position="static";while((e=e.parentNode)&&e.style);e=t._obj,e.style.position="fixed",e._width=e.style.width,e._height=e.style.height,e.style.width=e.style.height="100%",e.style.top=e.style.left=e.style.right="0px",
e.style.background="rgba(196,196,196,0.95)";
var n=document.body;n.scrollTop=0,n=n.parentNode,n&&(n.scrollTop=0),document.body._overflow=document.body.style.overflow||"",
document.body.style.overflow="hidden",document.documentElement.msRequestFullscreen&&t._obj&&window.setTimeout(function(){t._obj.style.width=window.outerWidth+"px"},1),t._maximize(),t.callEvent("onExpand",[])}},t.collapse=function(){if(t.callEvent("onBeforeCollapse",[])){var e=t._obj;do e.style.position=e._position;while((e=e.parentNode)&&e.style);e=t._obj,e.style.width=e._width,e.style.height=e._height,document.body.style.overflow=document.body._overflow,t._toggleFullScreen(!1),t._maximize(),t.callEvent("onCollapse",[]);
}},function(){var e=t.getState;t.getState=function(){var t=e.apply(this,arguments);return t.fullscreen=!!this._expanded,t}}(),t._maximize=function(){this._expanded=!this._expanded,this.render()},t._toggleFullScreen=function(t){!t&&(document.fullscreenElement||document.mozFullScreenElement||document.webkitFullscreenElement||document.msFullscreenElement)?document.exitFullscreen?document.exitFullscreen():document.msExitFullscreen?document.msExitFullscreen():document.mozCancelFullScreen?document.mozCancelFullScreen():document.webkitExitFullscreen&&document.webkitExitFullscreen():document.documentElement.requestFullscreen?document.documentElement.requestFullscreen():document.documentElement.msRequestFullscreen?document.documentElement.msRequestFullscreen():document.documentElement.mozRequestFullScreen?document.documentElement.mozRequestFullScreen():document.documentElement.webkitRequestFullscreen&&document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
}});
//# sourceMappingURL=../sources/ext/dhtmlxgantt_fullscreen.js.map 

