javascript:(function (){
	window.levelups = true;
	var rev=/,v \d+\.(\d+)\s201/.exec("$Id: levelupopener.js,v 1.5 2012-02-28 11:51:43 brandon Exp $")[1],
	version='Levelupopener v0.'+rev;
	var spocklet='levelupopen';
	window[spocklet+'_error_timer'] = false;
	var debug = false;
	var inact_log = {};
	var logs=[];
	var start_day = new Date().getDate();

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
	if (/apps.facebook.com.inthemafia/.test(document.location)) {
		//Credits to Christopher(?) for this new fix
		for (var i = 0; i < document.forms.length; i++) {
			if (/canvas_iframe_post/.test(document.forms[i].id) && document.forms[i].target == "mafiawars") {
				document.forms[i].target = '';
				document.forms[i].submit();
				return;
			}
		}
	}
	else if (document.getElementById('some_mwiframe')) {
		// new mafiawars.com iframe
		window.location.href = document.getElementById('some_mwiframe').src;
		return;
	}
	else {
		document.body.parentNode.style.overflowY = "scroll";
		document.body.style.overflowX = "auto";
		document.body.style.overflowY = "auto";
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
	}
	//end unframe code

	//hack to kill the resizer calls
	iframeResizePipe = function() {};
		
	var preurl = '//facebook.mafiawars.zynga.com/mwfb/remote/html_server.php?';
	
	//setup the initial html
	var style = '<style type="text/css">'+
		'.messages {border: 1px solid #888888; margin-bottom: 5px; -moz-border-radius: 5px; border-radius: 5px; -webkit-border-radius: 5px;}'+
		'.messages img{margin:0 3px;vertical-align:middle}'+
		'.messages input {border: 1px solid #888888; -moz-border-radius: 3px; border-radius: 3px; -webkit-border-radius: 2px;padding 0;background: #000; color: #FFF; width: 32px;}'+
//		'#'+spocklet+'_itemlist { display:none; margin-top:15px;}'+ //width:750px; height:520px; border:1px solid grey;

	'</style>';

	var spocklet_html =
	'<div id="'+spocklet+'_main">'+
		style+
		'<table class="messages">'+
		'<tr><td colspan="3" align="center" style="text-align:center;">'+
			'<a href="#" id="'+spocklet+'_friends" class="sexy_button_new green short"><span><span>Load Friends/Links</span></span></a>'+
			'&nbsp;<a href="http://www.spockholm.com/mafia/donate.php#'+spocklet+'" id="'+spocklet+'_donate" class="sexy_button_new short white" target="_blank" title="Like what we do? Donate to Team Spockholm" alt="Like what we do? Donate to Team Spockholm"><span><span>Donate</span></span></a>'+
//			'&nbsp;<a href="http://www.spockholm.com/mafia/help.php#" id="'+spocklet+'_help" class="sexy_button_new short" target="_blank" title="Get help" alt="Get help"><span><span>Help</span></span></a>'+
			'&nbsp;<a href="#" id="'+spocklet+'_stop" class="sexy_button_new short orange" title="Stop" alt="Stop"><span><span>Stop</span></span></a>'+
			'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<span class="good">'+version+'</span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'+
			'&nbsp;<a href="#" id="'+spocklet+'_close" class="sexy_button_new short red" title="Close" alt="Close"><span><span>Close</span></span></a>'+
		'</td></tr>'+
		'<tr><td colspan="3"><hr /></td></tr>'+
		'<tr><td colspan="3">Status: <span id="'+spocklet+'_status"></span></td></tr>'+
		'<tr><td colspan="3">Restart: <input id="'+spocklet+'_restart" type="checkbox" checked/></td></tr>'+
		'<tr><td colspan="3">Delay: <input id="'+spocklet+'_delay" type="number" value="3" style="width:40px;"/></td></tr>'+
		'<tr><td colspan="3">Start at Link #: <input id="'+spocklet+'_startat" type="number" value="0" style="width:40px;"/></td></tr>'+
		'<tr><td colspan="3">Stop at Link #: <input id="'+spocklet+'_stopat" type="number" value="0" style="width:40px;"/></td></tr>'+
		'<tr><td colspan="3">Delay Start: <input id="'+spocklet+'_delays" type="number" value="0" style="width:40px;"/></td></tr>'+
		'<tr><td colspan="3">Stop at Midnight: <input id="'+spocklet+'_midnstop" type="checkbox" checked/></td></tr>'+
		'<tr><td colspan="3">Experimental Error Recovery: <input id="'+spocklet+'_error" type="checkbox"/></td></tr>'+
		'<tr><td colspan="3"><span id="'+spocklet+'_output"></span></td></tr>'+
		'<tr><td colspan="3"><span id="'+spocklet+'_input"><textarea id="'+spocklet+'_inputdata" cols=80 rows=20></textarea></span><br />'+
		'&nbsp;<a href="#" id="'+spocklet+'_start" class="sexy_button_new short green" title="Start"><span><span>Start</span></span></a>'+
		'</td></tr>'+
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
	var rlinks = [];
	var run=false;

	function create_handler(){
		$('#'+spocklet+'_start').click(function(){
			run=true;
			if (parseInt($('#'+spocklet+'_delays').val()) > 0) {
				pausing(parseInt($('#'+spocklet+'_delays').val())*60,'Starting links in ',function(){ $('#'+spocklet+'_delays').val(0); $('#'+spocklet+'_start').trigger('click'); });
				return false;
			}
			else{
				load_links();
			}
			return false;
		});
			$('#'+spocklet+'_stop').click(function(){
			run = false;
			return false;
		});
		$('#'+spocklet+'_close').click(function() {
			run = false;
			window.levelups = false;
			$('#'+spocklet+'_main').remove();
		});
		$('#'+spocklet+'_error').change(function(){
			if($(this).is(':checked')){
				alert('This is *highly* experimental error recovery, if you are not having trouble with hang ups on error, uncheck this');
			}
		});
		$('#'+spocklet+'_friends').click(function(){
			FB.api('me/friends?limit=5000',function(resp){
				var output = [];
				for(var i = 0;i<resp.data.length;i++){
					output[output.length] = 'http://apps.facebook.com/inthemafia/track.php?xw_controller=index&xw_action=levelUpBonusClaim&friend_id='+resp.data[i].id+'&install_source=feed&indexnf=1';
					rlinks.push('http://apps.facebook.com/inthemafia/track.php?xw_controller=index&xw_action=levelUpBonusClaim&friend_id='+resp.data[i].id+'&install_source=feed&indexnf=1');
				}
				$('#'+spocklet+'_inputdata').val(output.join('\n'));
			});
		});
		$('#'+spocklet+'_friends').trigger('click');
	
	}
	
	
	function load_links(){
		links = [];
		stats.sum = 0;
		var m,linkstext=$('#'+spocklet+'_inputdata').val();
		var lines=linkstext.split(/[\n]/);
		for(var i=0;i<lines.length;i++){
			if(m=/(https?\:\/\/[^\s]*)/.exec(lines[i])) {
				links.push(m[1]);
			}
		}
		if($('#'+spocklet+'_startat').val() > 0){
			links.splice(0,$('#'+spocklet+'_startat').val());
		}
		$('#'+spocklet+'_inputdata').val(links.join("\n"));
		log("processing "+links.length+' links...');
		stats.sum=links.length;
		process_links();
	}
	
	
	function process_links(){
		if($('#'+spocklet+'_midnstop').is(':checked')){
			var day = new Date().getDate();
			if(start_day != day){
				$('#'+spocklet+'_stop').trigger('click');
				log("Midnight detected, stopped");
				return;
			}
		}
		if($('#'+spocklet+'_stopat').val() > 0 && parseInt(rlinks.length-links.length) >= $('#'+spocklet+'_stopat').val()){
			log("all links processed");
			if($('#'+spocklet+'_restart').is(':checked')){
				log("restarting.....");
				if(rlinks.length > 0){
					$('#'+spocklet+'_inputdata').val(rlinks.join("\n"));
					load_links();
				}
			}
			return;
		}
		if((links.length>0)&&run){
			var link=links.shift();
			$('#'+spocklet+'_inputdata').val(links.join("\n"));
			var delay = $('#'+spocklet+'_delay').val();
			//log("processing "+link);
			pausing(delay,'Next Link',unshort(link,function(longurl){
				if(/^https?:\/\/.*facebook/.test(longurl)) {
					request_fburl(longurl,function(response){
						clearTimeout(window[spocklet+'_error_timer']);
						window[spocklet+'_error_timer'] = false;
						var $p=$('<div>'+response.replace(/<img/ig, '<noimg')+'</div>');
						var result = $p.find('.message_body:first').text();
						var m;
						log(result);
						if(/You have already collected the maximum of 3 bonus rewards today/.test(result)){
							log('Maxed for the day, Stopping');
							$('#'+spocklet+'_stop').trigger('click');
							return;
						}
						if(m = /you received the following item from (?:.*)?: (.*)/.exec(result)){
							result = m[1];
						}
						stats.opened++; stats.total++;
						if(stats.msgs[result]) {
							stats.msgs[result]++;
						} else {
							stats.msgs[result]=1;
						}

						output();
						process_links();
					},function(e,r){
						if($('#'+spocklet+'_error').is(':checked') && !window[spocklet+'_error_timer']){
							window[spocklet+'_error_timer'] = setTimeout(function(){
								$('#'+spocklet+'_start').trigger('click'); 
							},60*1000)
						}
						log("Error loading link, trying next link \n Error: "+r);
						pausing(2,'Error occurred, next link in...',process_links);
						stats.failed++; stats.total++;
					});
				} else {
					log("not a correct url: "+longurl.substr(0,20)+"..., skipping");
					stats.failed++; stats.total++;
					output();
					process_links();
				}
			}));
		
		
		} else {
			log("all links processed");
			if($('#'+spocklet+'_restart').is(':checked')){
				log("restarting.....");
				if(rlinks.length > 0){
					$('#'+spocklet+'_inputdata').val(rlinks.join("\n"));
					load_links();
				}
			}
		}
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
		} else if(/(tinyurl|bit.ly|is.gd|goog.le)/.test(url)) {
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
//"$(this).hide(); var feed = { picture:'https://zyngapv.hs.llnwd.net/e6/mwfb/graphics/LimitedTimeProperty/CageFightingArena/feed-up_90x90-CageFightArena.png', source:'', link:'http://apps.facebook.com/inthemafia/track.php?next_controller=limitedTimeProperty&next_action=upgradeBragFeed&zy_track=feed&from=p|95497006&sendkey=29b1ee6ce396caa943a5c1879cb147e7$$cdI(VWPY13bNY5*Uv_O*SL-r*tOXIJRVZHhM5l8THuF_v47NXpa8vSorfMXH3t-ixb(QDUsCTCiU5VlJUTyz5eVQZOISzlZ(XSPaI1IHE7hv98jSaj-&next_params=%7B%22target_id%22%3A%22p%7C95497006%22%2C+%22prop_id%22%3A%2221%22%2C+%22tid%22%3A%221330249859%22%2C+%22remote_key%22%3A%22d8765e3ef361d2911ea3be9fb145995a96d4a69303262ebb0aa3ede72c47ec16%22%7D&sendtime=1330249860&friend=p|95497006', name:'Check out my upgraded Cage Fight Arena', caption:' ', description:'I just upgraded my Cage Fight Arena to level 9. Check it out for a chance to earn a free item.', userMessage:'', actionLinks:[{'name': 'Get Parts', 'link': 'http://apps.facebook.com/inthemafia/track.php?next_controller=limitedTimeProperty&next_action=upgradeBragFeed&zy_track=feed&from=p|95497006&sendkey=29b1ee6ce396caa943a5c1879cb147e7$$cdI(VWPY13bNY5*Uv_O*SL-r*tOXIJRVZHhM5l8THuF_v47NXpa8vSorfMXH3t-ixb(QDUsCTCiU5VlJUTyz5eVQZOISzlZ(XSPaI1IHE7hv98jSaj-&next_params=%7B%22target_id%22%3A%22p%7C95497006%22%2C+%22prop_id%22%3A%2221%22%2C+%22tid%22%3A%221330249859%22%2C+%22remote_key%22%3A%22d8765e3ef361d2911ea3be9fb145995a96d4a69303262ebb0aa3ede72c47ec16%22%7D&sendtime=1330249860&friend=p|95497006'}], attachment:null, targetId:0, callback:function(resp) { post_id = null; if (resp != null) { if (Util.isset(resp.post_id)) { post_id = resp.post_id; } else if (Util.isset(resp.id)) { post_id = resp.id; } } if(post_id) { $('#property_upgrade_share_btn').show(); upgradePostedFeed('remote/html_server.php?xw_controller=LimitedTimeProperty&xw_action=postedUpgradePropertyFeed&xw_city=1&tmp=ed735a44eb2f110fa334965c173891f0&cb=631364a0605f11e193a0dd6739cae22a&xw_person=95497006&mwcom=1&target_id=p%7C95497006&tid=1330249859&part_id=&prop_id=21&prop_level=9&key=d8765e3ef361d2911ea3be9fb145995a96d4a69303262ebb0aa3ede72c47ec16'); trackFBFeedSend('29b1ee6ce396caa943a5c1879cb147e7$$cdI(VWPY13bNY5*Uv_O*SL-r*tOXIJRVZHhM5l8THuF_v47NXpa8vSorfMXH3t-ixb(QDUsCTCiU5VlJUTyz5eVQZOISzlZ(XSPaI1IHE7hv98jSaj-', 1130821645, 1330249860, post_id); } else { upgradePostFailed(); } }, autoPublish:true, ref:'limited_time_p' }; MW.Feed(feed);"
	var timer;
	function pausing(seconds,message,resume_func) {
		if(seconds <= 0){
			if (typeof resume_func == 'function') {
				resume_func();
				return;
			}
		}
		var delay = (seconds > 0)? delay = 1000 : delay = 100;
		// if the message was left out, shuffle things a bit
		if (typeof message == 'function') {
			resume_func = message;
			message = null;
		}
		if (message) {
			message = message;
		}
		else {
			message='Pausing';
		}
		var minutes = (parseInt(seconds/60) == 1) ? 0 : parseInt(seconds/60);
		if (minutes > 0) {
			msg(message+' <span id="minutes">'+minutes+' minutes</span> <span id="seconds">'+(seconds%60)+' second'+(seconds==1?'':'s')+'</span>...');
		}
		else {
			msg(message+' <span id="minutes"></span><span id="seconds">'+(seconds%60)+' second'+(seconds==1?'':'s')+'</span>...');
		}
		timer = setInterval(function(){
			if (seconds%60 == 0) {
				minutes--;
			}
			seconds--;
			if (document.getElementById('minutes')) {
				document.getElementById('minutes').innerHTML = (minutes > 0) ? minutes+' minute'+(minutes==1?'':'s') : '';
			}
			if (document.getElementById('seconds')) {
				document.getElementById('seconds').innerHTML = (seconds % 60)+' second'+(seconds==1 ? '' : 's');
			}
			else {
				clearInterval(timer);
			}
			if (seconds <= 0) {
				clearInterval(timer);
				if (typeof resume_func == 'function') {
					resume_func();
				}
			}
		},delay);
	}

	function request_fburl(url, handler, errorhandler) {
		url = url.replace('http://apps.facebook.com/inthemafia/track.php?','');
		url = url.replace('https://apps.facebook.com/inthemafia/track.php?','');
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
	function msg(m){
		$('#'+spocklet+'_status').html(m);
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
	
	window.onbeforeunload = function() {
		if(levelups){
			return 'You\'re closing your level up window!';
		}
	}

	
})();
