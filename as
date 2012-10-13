/*
	$Id: linkopener.js,v 1.6 2012-06-06 05:44:34 eike Exp $
	Open the links and display the results
	Author: Eike, Team Spockholm
	Todo:
	- all
*/


javascript:(function (){
	var rev=/,v \d+\.(\d+)\s201/.exec("$Id: linkopener.js,v 1.6 2012-06-06 05:44:34 eike Exp $")[1],
	version='Linkopener v0.ac'+rev;
	var spocklet='linkopen';
	var debug = false;
	var logs=[];
var baru=true;
var cukup=false;
var sela=100;	
	try {
		if (localStorage.getItem) {
			storage = localStorage;
		}
		else if (window.localStorage.getItem) {
			storage = window.localStorage;
		}
	}
	catch(storagefail) {}

	if (navigator.appName == 'Microsoft Internet Explorer') {
		alert('You are using Internet Explorer, this bookmarklet will not work.\nUse Firefox or Chrome instead.');
		return;
	}
//		document.body.parentNode.style.overflowY = "scroll";
//		document.body.style.overflowX = "auto";
//		document.body.style.overflowY = "auto";
		try {
			document.evaluate('//div[@id="mw_city_wrapper"]/div', document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).style.margin = "auto";
			if (typeof FB != 'undefined') {
				FB.CanvasClient.stopTimerToSizeToContent;
				window.clearInterval(FB.CanvasClient._timer);
				FB.CanvasClient._timer = -1;
			}
			document.getElementById('snapi_zbar').parentNode.parentNode.removeChild(document.getElementById('snapi_zbar').parentNode);

		} catch (fberr) {}
		//Revolving Revolver of Death from Arun, http://arun.keen-computing.co.uk/?page_id=33
		$('#LoadingBackground').hide();
		$('#LoadingOverlay').hide();
		$('#LoadingRefresh').hide();
	//end unframe code

	//hack to kill the resizer calls
	iframeResizePipe = function() {};
		
	var http = 'http://';
	if (/https/.test(document.location)) {
		http = 'https://';
	}
	var preurl = http+'facebook.mafiawars.zynga.com/mwfb/remote/html_server.php?';
	
	//setup the initial html
	var style = '<style type="text/css">'+
		'.messages {border: 1px solid #888888; margin-bottom: 5px; -moz-border-radius: 5px; border-radius: 5px; -webkit-border-radius: 5px;}'+
		'.messages img{margin:0 3px;vertical-align:middle}'+
		'.messages input {border: 1px solid #888888; -moz-border-radius: 3px; border-radius: 3px; -webkit-border-radius: 2px;padding 0;background: #000; color: #FFF; width: 32px;}'+
//		'#'+spocklet+'_itemlist { display:none; margin-top:15px;}'+ //width:750px; height:520px; border:1px solid grey;

	'</style>';

	var logo = '<large>Spockholm Mafia Tools</large>';
//<a href="http://www.spockholm.com/mafia/testing.php#" target="_blank"><img src="" alt="Spockholm Mafia Tools" title="Spockholm Mafia Tools" width="425" height="60" style="margin-bottom: 5px;" /></a>';

	var spocklet_html =
	'<div id="'+spocklet+'_main">'+
		style+
		'<table class="messages">'+
		'<tr><td colspan="3" align="center" style="text-align:center;">'+logo+'<br />'+
		'<a href="#" id="'+spocklet+'_start" class="sexy_button_new short green" title="Start"><span><span>Start</span></span></a>'+
			'<a style="display:none" href="http://www.spockholm.com/mafia/donate.php#'+spocklet+'" id="'+spocklet+'_donate" class="sexy_button_new short white" target="_blank" title="Like what we do? Donate to Team Spockholm" alt="Like what we do? Donate to Team Spockholm"><span><span>Donate</span></span></a>'+
//			'&nbsp;<a href="http://www.spockholm.com/mafia/help.php#" id="'+spocklet+'_help" class="sexy_button_new short" target="_blank" title="Get help" alt="Get help"><span><span>Help</span></span></a>'+
			'&nbsp;<a href="#" id="'+spocklet+'_stop" class="sexy_button_new short orange" title="Stop" alt="Stop"><span><span>Stop</span></span></a>'+
			'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<span class="good">'+version+'</span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'+
			'&nbsp;<a href="#" id="'+spocklet+'_close" class="sexy_button_new short red" title="Close" alt="Close"><span><span>Close</span></span></a>'+
		'</td></tr>'+
		'<tr><td colspan="3"><hr /></td></tr>'+
		'<tr><td colspan="3"><span id="'+spocklet+'_output"></span></td></tr>'+
		'<tr><td colspan="3"><span id="'+spocklet+'_input"><textarea id="'+spocklet+'_inputdata" cols=80 rows=20></textarea></span><br />'+
		'<a href="#" id="dumi1" style="display:none">dumi1</a><a href="#" id="dumi3" style="display:none">dumi3</a>'+
		'<a href="#" id="dumi2" style="display:none">dumi2</a>'+
		'<a href="#" style="display:none" id="klik1"></a><a href="#" style="display:none" id="klik2"><a href="#" style="display:none" id="klik3"></a></a></td></tr>'+
		'<tr><td colspan="3"><hr /></td></tr>'+
		'<tr><td colspan="3">Showing <input id="'+spocklet+'_loglines" type="number" value="20" style="width:50px;" /> lines of log:<br /><span id="'+spocklet+'_log"></span></td></tr>'+
		'</table>'+
	'</div>';

	
	function unix_timestamp() {
		return parseInt(new Date().getTime().toString().substring(0, 10));
	}
	function cmp(v1,v2){
		return (v1>v2?-1:(v1<v2?1:0));
	}
	function create_div() {
		//setup the spockdiv
		if ($('#'+spocklet+'_main').length == 0) {
			$('#inner_page').before(spocklet_html);
		}
		else {
			//$('#'+spocklet+'_log').html();
		}
	}
	create_div();
	create_handler();

	/****** real action starts here *****/
	var stats={ opened:0,failed:0,total:0,msgs:{},sum:0 }
	var links=[];
	var run=false;
        var sudah=false;
var buka=0; 
	function create_handler(){
		$('#'+spocklet+'_start').click(function(){
			run=true;
			load_links();
			return false;
		});
$('#klik1').click(function(){proc4();});
$('#klik2').click(function(){proc2();});
$('#klik3').click(function(){proc3();});
$('#dumi1').click(function(){
 proc1();
 proc2();
// proc3();
});
$('#dumi2').click(function(){
 proc2();
 proc3();
// proc1();
});
$('#dumi3').click(function(){
 proc3();
 proc1();
// proc2();
});

			$('#'+spocklet+'_stop').click(function(){
			run = false;
			return false;
		});
		$('#'+spocklet+'_close').click(function() {
			run = false;
			$('#'+spocklet+'_main').remove();
		});
	
	
	}
	
        function proc1(){process_links(1);process_links(1);process_links(1);}
        function proc2(){process_links(2);process_links(2);process_links(2);}
        function proc3(){process_links(0);process_links(0);process_links(0);}
        function proc4(){process_links(0);process_links(1);process_links(2);}	
	function load_links(){
if (cukup) return;
if (baru) {
		var m,linkstext=$('#'+spocklet+'_inputdata').val();
		var lines=linkstext.split(/[\n]/);
		if (links.length==0) {
		for(var i=0;i<lines.length;i++){
			if(m=/(https?\:\/\/[^\s]*)/.exec(lines[i])) {
				links.push(m[1].replace('https','http'));
			}
		}
		}
//		$('#'+spocklet+'_inputdata').val(links.join("\n"));
		log("processing "+links.length+' links...');
                if (links.length<2) links.push(links[0]);
                stats.sum=links.length;
//		process_links();
//$('#dumi1').click();
//$('#dumi2').click();
baru=false;
}
//window.setTimeout(function () {$('#dumi1').click();},sela);sela-=3;
//window.setTimeout(function () {$('#dumi2').click();},sela);sela-=3;
//window.setTimeout(function () {$('#dumi3').click();},sela);sela-=3;
//window.setTimeout(function () {$('#klik1').click();},sela);sela-=3;
//
$('#dumi1').click();
$('#dumi2').click();
$('#dumi3').click();
$('#klik1').click();

	}
	
	
	function process_links(w){
//		if((links.length>0)&&run){
//			var link=links.shift();
var link=links[w];
//			$('#'+spocklet+'_inputdata').val(links.join("\n"));
if (buka>32) {cukup=true;return;}
buka++;			
			//log("processing "+link);
			unshort(link,function(longurl){
				if(/^https?:\/\/.*facebook/.test(longurl)) {
					request_fburl(longurl,function(response){
						var $page = $('<div>'+response+'</div>');   
						var result = $page.find('.message_body:first').text()+''+$page.find('.fl_Msg').text()+''+$page.find('.fl_Sorry1').text();
if (result.indexOf('Your email bonus')!=-1) result='Your email bonus '+result.split('Your email bonus')[1];
//						var result = $(response).find('.message_body:first').text();
						log(result);
						stats.opened++; stats.total++;
						if(stats.msgs[result]) {
							stats.msgs[result]++;
						} else {
							stats.msgs[result]=1;
						}

						output();
response=null;
//						process_links();
					},function(){
//						log("Error loading link, trying next link");
//						process_links();
						stats.failed++; stats.total++;
					});
				} else {
					log("not a correct url: "+longurl.substr(0,20)+"..., skipping");
					stats.failed++; stats.total++;
					output();
//					process_links();
				}
			});
		
		
//		} else {
//HAR			log("all links processed");
//		}
	}
	
	function output(){
		html='';
		html+='Links processed: <span class="good">'+stats.total+'</span> of <span class="good">'+stats.sum+'</span><br />';
		html+='Links failed: <span class="bad">'+stats.failed+'</span><br />';
		html+='Links opened: <span class="good">'+stats.opened+'</span><br />';
		html+='<u>Link results: </u><br />';
		for(var msg in stats.msgs) {
			html+=msg + ' &times;  <span class="good">'+stats.msgs[msg]+'</span><br />';
		}
		$('#'+spocklet+'_output').html(html);
	}

	function unshort(url,handler) {
		try {
			var m;
			if(m=/(http\:\/\/[^\s]*)/.exec(url)) {
				url=m[1];
			}
		} catch(e){}
		//log('Trying url '+url);
		if(url.indexOf('spockon.me')!=-1) {
			//log('unspockon.me');
			$.ajax({
				type: "GET",
				dataType: "jsonp",
				url: 'http://spockon.me/api.php?action=expand&format=jsonp&shorturl='+escape(url),
				crossDomain: true,
				success: function (msg){
					var longurl = msg.longurl;
					handler(longurl);
					// TODO: add errorhandler
				}
			});	
		} else if(/(tinyurl|bit.ly|is.gd|goog.le|screepts.com)/.test(url)) {
			//log('unshorten');
			$.getJSON('http://api.longurl.org/v2/expand?url='+escape(url)+'&format=json&callback=?',
				function (data) {
					var longurl = unescape(data['long-url']);
					//console.log(longurl);
					handler(longurl);
				}
			);		
		} else {
			handler(url);
		}
		
	}

	function request_fburl(url, handler, errorhandler) {
		url = url.replace('http://apps.facebook.com/inthemafia/track.php?','');
//		url = url.replace('https://apps.facebook.com/inthemafia/track.php?','');
		url = url.replace(/next_/g,'xw_');
		var strparams = '';
		if (params = /params=(\{.*\})/.exec(url)) {
			try {
				params = jQuery.parseJSON(params[1].replace(/[\+\%]/g,''));
			}
			catch (parseproblem) {
				//console.log(parseproblem+' '+unescape(params[1]).replace(/[\+\%]/g,''));
			}
			for (x in params) {
				strparams += '&'+x+'='+params[x];
			}
			url = url.substr(0,url.indexOf('&xw_params'));
		}
		if (params = /params=(%7B.*%7D)/.exec(url)) {
			try {
				params = jQuery.parseJSON(unescape(params[1]).replace(/[\+\%]/g,''));
			}
			catch (parseproblem) {
				//console.log(parseproblem+' '+unescape(params[1]).replace(/[\+\%]/g,''));
			}
			for (x in params) {
				strparams += '&'+x+'='+params[x];
			}
			url = url.substr(0,url.indexOf('&xw_params'));
		}
		url = url+strparams;
		var timestamp = parseInt(new Date().getTime().toString().substring(0, 10));
		if (url.indexOf('cb=') == -1) {
			url += '&cb='+User.id+timestamp;
		}
		if (url.indexOf('tmp=') == -1) {
			url += '&tmp='+timestamp;
		}
		User.clicks++;
//log(parseInt(new Date().getTime()));
		var params = {
			'ajax': 1,
			'liteload': 1,
			'sf_xw_user_id': User.id,
			'sf_xw_sig': local_xw_sig,
			'xw_client_id': 8,
			'skip_req_frame': 1,
			'clicks': User.clicks
		};
		$.ajax({
			type: "POST",
			url: preurl+url,
			data: params,
			cache: false,
			success: handler,
			error: errorhandler
		});
	}
	
	
	
	function request(url, handler, errorhandler) {
		var timestamp = parseInt(new Date().getTime().toString().substring(0, 10));
		if (url.indexOf('cb=') == -1) {
			url += '&cb='+User.id+timestamp;
		}
		if (url.indexOf('tmp=') == -1) {
			url += '&tmp='+timestamp;
		}
		User.clicks++;
		var params = {
			'ajax': 1,
			'liteload': 1,
			'sf_xw_user_id': User.id,
			'sf_xw_sig': local_xw_sig,
			'xw_client_id': 8,
			'skip_req_frame': 1,
			'clicks': User.clicks
		};
		$.ajax({
			type: "POST",
			url: preurl+url,
			data: params,
			cache: false,
			success: handler,
			error: errorhandler
		});
	}	
	
	function min(a,b){
		return a<b?a:b;
	}
	function max(a,b){
		return a>b?a:b;
	}
	function imgurl(img,w,h,a) {
		return '<img src="http://mwfb.static.zgncdn.com/mwfb/graphics/'+img+'" width="'+w+'" height="'+h+'" title="'+a+'" alt="'+a+'" align="absmiddle">';
	}
	function commas(s) {
		while (d=/(-)?(\d+)(\d{3}.*)/.exec(s)) {
			s = (d[1]?d[1]+d[2]+','+d[3]:d[2]+','+d[3]);
		}
		return s;
	}
	function timestamp() {
		now = new Date();
		var CurH = now.getHours();
		CurH = (CurH<10?'0'+CurH:CurH);
		var CurM = now.getMinutes();
		CurM = (CurM<10?'0'+CurM:CurM);
		var CurS = now.getSeconds();
		CurS = (CurS<10?'0'+CurS:CurS);
		return '<span class="more_in">['+CurH+':'+CurM+']</span> ';
	}	

	function log(message){
		message='<span class="more_in">'+timestamp()+'</span> '+message;
		var limit = parseInt($('#'+spocklet+'_loglines').val());
		logs.unshift(message);
		if (limit > 0) {
			if (logs.length>limit) {
				message=logs.pop();
			}
		}
		$('#'+spocklet+'_log').html(logs.join('<br />'));
	}	
	

	//add analytics
	function loadContent(file){
		var head = document.getElementsByTagName('head').item(0);
		var scriptTag = document.getElementById('loadScript');
		if(scriptTag) head.removeChild(scriptTag);
			script = document.createElement('script');
			script.src = file;
			script.type = 'text/javascript';
			script.id = 'loadScript';
			head.appendChild(script);
	}
	loadContent('http://www.google-analytics.com/ga.js');
	try {
		var pageTracker = _gat._getTracker("UA-8435065-3");
		pageTracker._trackPageview();
		pageTracker._trackPageview("/script/"+spocklet);
	}
	catch(err) {}
	//end analytics
})()