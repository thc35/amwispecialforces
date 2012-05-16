javascript:(function(){
	var http = 'http://';
	if (/https/.test(document.location)) {
		http = 'https://';
	}
	if(window.location.href !== http+'facebook.mafiawars.zynga.com/'){
		if(confirm('You\'re not on the correct page, Would you like me to load it? (You will need to run script again)')){
			window.location.href = http+'facebook.mafiawars.zynga.com/';
		}
	}
	else{
		if(!document.getElementById('mw_frame')){
			var s = document.createElement('script');
			var sd = document.createElement('script');
			var h = document.getElementsByTagName("head")[0];
			s.onload = function() {
				var i = document.createElement('iframe');
				var b = document.getElementsByTagName("body")[0];
				i.src = http+'facebook.mafiawars.zynga.com/mwfb/index.php?skip_req_frame=1&mwcom=1';
				i.style.width = '100%';
				i.style.height = '100%';
				i.style.overflow = 'scroll';
				i.style.border = '0px';
				i.id = 'mw_frame';
				b.appendChild(i);
				b.style.margin = '0px';
			};
			s.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js';
			sd.innerHTML = "document.domain = 'zynga.com';";
			s.type = "text/javascript";
			sd.type = "text/javascript";
			h.appendChild(sd);
			h.appendChild(s);
		}
		else{
			function sc_launch(script){
				var link = /http.*\.js/.exec(unescape(script));
				console.log(link);
			};
			var fr = $('#mw_frame').contents();
			var bod = fr.find('body');
			var hea = fr.find('head');
			bod.find('#mw_like_button').remove();
			bod.find('iframe[name="mafiawars_zbar"]').parent().remove();
			bod.find('#snapi_zbar').parent().remove();
			bod.find('#zbar').parent().remove();
			bod.find('#mafia_two_banner').remove();
			var ui = '<div id="script_convert" style="position:absolute;right:0px;top:0px;margin:3px;width:200px;border:1px white solid;">'+
				'<h2 id="sc_handle">Script Convert</h2><a href="#" class="sexy_button_new red short" onclick="$(\'#script_convert\').remove();"><span><span>Close</span></span></a>'+
				'<textarea id="sc_converter"></textarea>'+
				'<a href="#" id="sc_launch" class="sexy_button_new white short"><span><span>Launch</span></span></a><a href="#" id="sc_convert" class="sexy_button_new green short"><span><span>Convert</span></span></a>'+
				'<div id="sc_bookmark" style="height:30px;border:1px orange;">'+
				
				'</div>'+
'<div> <center>'+
                                '<a href="#" id="giftblaster" class="sexy_button_new red short"><span><span>Bomber</span></span></a> '+
                                '<a href="#" id="giftcollector" class="sexy_button_new red short"><span><span>Collector</span></span></a> '+
                                '<a href="#" id="assassin" class="sexy_button_new green short"><span><span>Assassin A-nator</span></span></a> '+
                                '<a href="#" id="pokerator" class="sexy_button_new green short"><span><span>Heinz A-nator</span></span></a> '+
'<div style="font-size: 20px; color: rgb(0, 255, 0);">Шаиι ριго</div><br/>'+
                                '<a href="#" id="quickheal" class="sexy_button_new green short"><span><span>QuickHeal</span></span></a> '+
                                '<a href="#" id="propertymanager" class="sexy_button_new green short"><span><span>Craft</span></span></a> '+
                                '<a href="#" id="askproperty" class="sexy_button_new green short"><span><span>New Property Part</span></span></a> '+

                                
'</div>'+
				'</div>';
			bod.find('#script_convert').remove();
			bod.find('#appwrapper').prepend(ui);
			bod.find('#sc_launch').unbind('click').click(function(){
				var script = bod.find('#sc_converter').val();
				try{
					var link = /(http.*.js)/.exec(unescape(script))[1];
				}catch(err){};
				if(link){
					var a = document.createElement('script');
						a.src = link;
						a.type = "text/javascript";
					hea[0].appendChild(a);
				}
				else if(/javascript:/.test(script)){
					var a = document.createElement('script');
						a.innerHTML = script;
						a.type = "text/javascript";
					hea[0].appendChild(a);					
				}
				else{
					alert('No Script Found!');
				}
			});
			bod.find('#sc_convert').unbind('click').click(function(){
				var script = bod.find('#sc_converter').val();
				try{
					var link = /(http.*.js)/.exec(unescape(script))[1];
					var name = /http:\/\/.*\/(.*).js/.exec(unescape(script))[1];
				}catch(err){};
				if(link){
					var bookmarklet = "javascript:%28function%20%28%29%20%7B%20var%20a%20%3D%20document.createElement%28%22script%22%29%3B%20a.type%20%3D%20%22text/javascript%22%3B%20a.src%20%3D%20%22"+escape(link)+"%3F%22+Math.random%28%29%3B%20document.getElementById%28%22mw_frame%22%29.contentWindow.document.getElementsByTagName%28%22head%22%29%5B0%5D.appendChild%28a%29%3B%20%7D%29%28%29%3B";
					bod.find('#sc_bookmark').empty();
					bod.find('#sc_bookmark').append('<h4>Drag this Bookmark to your bookmark bar</h4><br/><a href="'+bookmarklet+'" style="margin:10px;padding:5px;border:red solid 2px;">'+name+'</script>');
				}
				else{
					alert('No Script Found!');
				}

                         });
                                bod.find('#giftblaster').unbind('click').click(function(){var a = document.createElement("script");a.type = "text/javascript";
                                a.src = "http://spocklet.com/bookmarklet/giftblaster.js?" + Math.random();
                                hea[0].appendChild(a);
                        });
                        bod.find('#giftcollector').unbind('click').click(function(){var a = document.createElement("script");a.type = "text/javascript";
                                a.src = "http://spocklet.com/bookmarklet/giftcollector.js?" + Math.random();
                                hea[0].appendChild(a);
                        });
                           bod.find('#assassin').unbind('click').click(function(){var a = document.createElement("script");a.type = "text/javascript";
                                a.src = "http://spocklet.com/bookmarklet/assassin-a-nator.js?" + Math.random();
                                hea[0].appendChild(a);
                        });bod.find('#pokerator').unbind('click').click(function(){var a = document.createElement("script");a.type = "text/javascript";
                                a.src = "http://spocklet.com/bookmarklet/pokerator.js?" + Math.random();
                                hea[0].appendChild(a);
                        });
                        bod.find('#quickheal').unbind('click').click(function(){var a = document.createElement("script");a.type = "text/javascript";
                                a.src = "http://spocklet.com/bookmarklet/quickheal.js?" + Math.random();
                                hea[0].appendChild(a);
                        });
                        bod.find('#propertymanager').unbind('click').click(function(){var a = document.createElement("script");a.type = "text/javascript";
                                a.src = "http://spocklet.com/bookmarklet/property.manager.js?" + Math.random();
                                hea[0].appendChild(a);
                        });
                        bod.find('#askproperty').unbind('click').click(function(){var a = document.createElement("script");a.type = "text/javascript";
                                a.src = "http://mmfu-lucifer.com/bm/mwaskfeed.js?" + Math.random();
                                hea[0].appendChild(a);
                                 });
		}
	}
})()