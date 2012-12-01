//////////////////////////////////////////////////////////////////////////////////////////////
//          This code was brought to you by todays letters kids 666                         //
//                http://screepts.com muahahahaha                                           //
//                      if you love it share it!!!                                          //
//{Don't be evil & remove my header or anyone else, love it, leave it & share it...}        //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////
// Copyright(C) 2011 Luke Hardiman, luke@hardiman.co.nz                                     //
// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php       //
//////////////////////////////////////////////////////////////////////////////////////////////
//Notes:
//This is a modification of the orginal mission link script from Team Spockholm, http://spocklet.com/bookmarklet/missionlink.js
//This modified version was created for people using MWAP & users requesting for links to be created on the fly. 
//Any problems with this mod please contact me @ luke@hardiman.co.nz
//All Credits go to :
/*
	$Id: missionlink.js,v 1.34 2012-03-17 06:16:49 eike Exp $
	Mission link generator

Script is old needs a rewrite, shame....
*/

javascript:(function (){

var post_groups = false;
var groups;
var wall_button = true;
var stopme= false;
//Storage to save links for posting use

 var proplinks = {
      shortner:'tinyurl',
      link : '',
      name : '',
      picture : '',
      description : '',
      shortlink:'',
      longlink:'',
      link1 :{name:'',shortlink:'',longlink:''},
      link2 :{name:'',shortlink:'',longlink:''},
      link3 :{name:'',shortlink:'',longlink:''}
     
  }

  
try {
    if (localStorage.getItem) {
        storage = localStorage;
    }
    else if (window.localStorage.getItem) {
        storage = window.localStorage;
    }
}catch(failsafe) {
            //Fall Cookie Store...
}

function iMergeOptions(obj1,obj2){
/*
 * Merges options from storage with the local options 
 * helps with adding adding new settings to script back to storage
 */    
    var obj3 = {};
    for (var attrname in obj1) {obj3[attrname] = obj1[attrname];}
    for (var attrname in obj2) {obj3[attrname] = obj2[attrname];}
    return obj3;
}   
//Load Settings
if (storage) {
var proplinks_store = storage.getItem('proplinks1');

    if(proplinks_store){
        proplinks = JSON.parse(proplinks_store);
    }
    
 
//just so no one looses the data from json changes
//proplinks = iMergeOptions(proplinks,savedproplinks)
    
    

   //log(concat(proplinks.link1));
}

function save_storage(){
  try {
//Save Settings
if (storage) {
storage.setItem('proplinks1',JSON.stringify(proplinks));
}
} catch(e) {
alert('Local Storage is probably full.');
//store as cookie
}
  
}
try{
//openUpgrade();
}catch(err){}
//Globals
var shortener_url="http://screepts.com/api.php";
var beggingobjects=[];
var params = {};
var http = 'http://';
if (/https/.test(document.location)) {
	http = 'https://';
}

String.prototype.trunc = function(n){
                          return this.substr(0,n-1)+(this.length>n?'...':'');
};
                         
var preurl = http+'facebook.mafiawars.zynga.com/mwfb/remote/';

if (navigator.appName == 'Microsoft Internet Explorer') {
		alert('You are using Internet Explorer, this bookmarklet will not work.\nUse Firefox or Chrome instead.');
return;
}


$("#linkProgress").progressbar();

//$("#linkProgress").progressbar({value:4})   



var userid =/sf_xw_user_id': '(.+)'/.exec(document.body.innerHTML)[1];

function GetGroups(handler) {
        

var a = [326145474133181,504726656220529,265769236858667,330858370267528,242835359156933,137879702894830,336765332862,490584710971204,143447472451323,161635587249832,
         130575993669197,202331273150926,216815885035880,1544104762,173236399415354,272597376152957,344674472256793];        
     

//FB.login(function (response) {
    
var access_token;
//if (Util.isset(response.authResponse)) {
//access_token = response.authResponse.accessToken;
 $("#linkProgress").progressbar({value: 5});
FB.getLoginStatus(function(response) {
     $("#linkProgress").progressbar({value: 10});
			if (Util.isset(response.authResponse)) {
				var access_token = response.authResponse.accessToken;
				FB.api('/me/groups?access_token='+access_token,function(data){
                                     $("#linkProgress").progressbar({value: 15});                                                   
                                                    if (data.data.length > 0){
                                                       
                                                    
                                                    for (var id in data.data)
                                                    {
                                                        //alert(data.data);
                                                       if (!(data.data[id].id == undefined)){
                                                            var group_id = parseInt(data.data[id].id);         
                                                                if($.inArray(group_id,a) > -1) {
                                                                     //groups = groups + '<option value="0">*N/A '+data.data[id].name.trunc(50)+'</option>';//log(groups);
                                                                    }else{
                                                                    groups = groups + '<option value="'+data.data[id].id+'">'+data.data[id].name.trunc(45)+'</option>';//log(groups);
                                                                }    
                                                            }
                                                    }
                                                post_groups = true;
                                               
                                                     
                                            }else{
                                                post_groups = false;
                                               
                                            }
				});
			}
		
		});
                //

                                        
                       
                      //  } 
//});
 


 

 

}
	function request(url, handler, errorhandler) {
            
            if (stopme == true)return;
            
		var cb = userid;
		var ts = 'a';
		var params = { 
			'ajax': 1, 
			'liteload': 1, 
			'sf_xw_user_id': userid,
			'sf_xw_sig': local_xw_sig,
			'xw_client_id': 8,
			'skip_req_frame': 1
		};
		$.ajax({
			type: "POST",
			url: preurl+url+'&cb='+cb+'&tmp='+ts,
			data: params,
			//dataType: 'json',
			 cache: false,
			success: handler,
			error: errorhandler
		});
	}

	function shorten(url, handler) {
/*
 * Shorten long link & return  
 */
 if (stopme == true)return;
   var parse ;
switch(proplinks.shortner)
{
    
case 'screepts':parse =  {url: url,service:'screepts'};
    break;
case 'spockon.me':
  $.ajax({
			type: "GET",
			dataType: "jsonp",
			url: 'http://spockon.me/api.php?action=shorturl&format=jsonp&url='+escape(url),
			crossDomain: true,
                        timeout: 30000,
			error: function(e){
                            log(concat(e))
                        },
			success: function (msg){
				handler(msg.shorturl);
			}
    });
  break;

default:
parse =  {url: url,service:'tinyurl'}
break;  
}     
$.getJSON('http://mwscripts.com/api/url-shortener.php?&callback=?', parse,
function(data){
    handler(data.shortlink);
})		
       
}
		

function getBeggingPartOther(){
/*
 * Get Begginging links
 */
         if (stopme == true)
             return;
         
                try{
                if (typeof property_ask_any != "undefined") {
                    
                //set progress bar
               
                $("#linkProgress").progressbar({value: 17});
                $('#LucifersLinksArea').val('Any Part');  
                proplinks.longlink = window.property_ask_any.link;
                
                
               
               
		shorten(window.property_ask_any.link,function(short_link){
                    
                
                    
                $("#linkProgress").progressbar({value: 20});
                $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+' => '+short_link+'\n');
                try{
                    
                //$("#linkProgress").progressbar({value: 4});
                proplinks.shortlink = short_link;
               }catch(err){}
               $("#linkProgress").progressbar({value: 25});
                window.property_ask_any.callback({post_id: 42});
                save_storage();
                getObjectsOther(activateLinks)
		});
                }else{
                 getObjectsOther(activateLinks)
                }}catch(err){
                getObjectsOther(activateLinks)
                log(err)
                }
  
	
                

	}
function getObjectsOther(handler){
             if (stopme == true)return;
			//request('html_server.php?xw_controller=LimitedTimeProperty&xw_action=showProperties&mwcom=1&view_tab=upgrade&page_click=home_page',function(response){
                        request('html_server.php?xw_controller=LimitedTimeProperty&xw_action=getNewUpgradeTable&xw_city=1&id=32',function(msg){
                                var m
       
               
				window.eike=msg;
				if (m=/var property_part\d+ = ([^\<]*)\</.exec(msg)) {
					
                                        $("#linkProgress").progressbar({value: 30});
					eval('window.pp='+m[1]);
					window.remaining=msg.substr(msg.indexOf(m[1]));
					
					if(m=/needs more (.*) to/.exec(window.pp.name)) {
						//window.pp.itemname = m[1];
                                                $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+m[1]);
					}
                                                $("#linkProgress").progressbar({value: 40});
					shorten(window.pp.link,function(shortlink){
                                             $("#linkProgress").progressbar({value: 50});
                                            try{
                                             //$("#linkProgress").progressbar({value: 4});
                                             proplinks.link1.name = m[1];
                                             proplinks.link1.longlink = window.pp.link
                                             proplinks.link1.shortlink = shortlink;
                                             
                                             save_storage();
                                              }catch(err){}
                                             $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+' => '+shortlink+'\n');
						//window.pp.shortlink=shortlink;
						beggingobjects.push(window.pp);
						if (m=/var property_part\d+ = ([^\<]*)\</.exec(window.remaining)) {
                                                        $("#linkProgress").progressbar({value: 60});
							eval('window.pp='+m[1]);
							window.remaining=window.remaining.substr(window.remaining.indexOf(m[1]));
							if(m=/needs more (.*) to/.exec(window.pp.name)) {
								//window.pp.itemname = m[1];
                                                               $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+m[1]);
							}

							shorten(window.pp.link,function(shortlink){
                                                            $("#linkProgress").progressbar({value: 70});
                                                                try{
                                                                    
                                                                    
                                                                //$("#linkProgress").progressbar({value: 6});
                                                                proplinks.link2.name = m[1];
                                                                proplinks.link2.longlink = window.pp.link;
                                                                proplinks.link2.shortlink = shortlink;
                                                                save_storage();
                                                                }catch(err){}
                                                             $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+' => '+shortlink+'\n');
								//window.pp.shortlink=shortlink;
								beggingobjects.push(window.pp);
								if (m=/var property_part\d+ = ([^\<]*)\</.exec(window.remaining)) {
                                                                        $("#linkProgress").progressbar({value: 80});
									eval('window.pp='+m[1]);
									if(m=/needs more (.*) to/.exec(window.pp.name)) {
										//window.pp.itemname = m[1];
                                                                                 $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+m[1]);
									}

                                                                        //$("#linkProgress").progressbar({value: 6});
                                                                        $("#linkProgress").progressbar({value: 90});
									shorten(window.pp.link,function(shortlink){
                                                                        try{
                                                                            
                                                                        $("#linkProgress").progressbar({value: 100});
                                                                        proplinks.link3.name = m[1];
                                                                        proplinks.link3.longlink = window.pp.link;
                                                                        proplinks.link3.shortlink = shortlink;
                                                                        save_storage();
                                                                        }catch(err){}
										window.pp.shortlink=shortlink;
                                                                                $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+' => '+shortlink+'\n');
										beggingobjects.push(window.pp);

										handler();						
									});
								} else {
									handler();						
								}	
							});
						} else {
                                                    handler();
						}	
					});
				} else {
                                     old_links(ifinished);
				}
                              

                        
			});
		}          	
function activateLinks(handler){
/*
 * Activate Links
 */    

for(var i=0;i<beggingobjects.length;i++){

try{window.MW.Feed(beggingobjects[i]);}catch(e){}
}
ifinished();
}

function old_links(handler,longlink){
    

$("#linkProgress_bar").show();
$("#links_loading").show();
$("#shortlink_service_button").hide();
var shortlinkit,links;
$("#linkProgress_bar").hide();
  
if (!longlink){
var doIt=confirm('Your not ready to ask for parts yet.\nWait for the \'ASK\' button to be showing.\n\nWould you like to try & load the previous links?');
if (doIt){
    $("#linkProgress_bar").hide();
    doBackup();
    //return;
}
}else{
   
    longlink =true;
    doBackup();
}
function doBackup(){
                                            try{
                                                
                                            $('#LucifersLinksArea').val('');
                                          var links = '';
                                          if (proplinks.shortlink.indexOf("http://") != -1 ){
                                             if(longlink ==true){
                                                  
                                                  
                                                  if(proplinks.longlink){
                                                    
                                                    shorten(proplinks.longlink,function(sshortend){
                                                  
                                                        links  = "Any Part => "+sshortend+'\n';
                                                        proplinks.shortlink = sshortend;
                                                    $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+links) 
                                                    })
                                                    }
                                                }else{
                                                    links = "Any Part => "+proplinks.shortlink;
                                                    $('#LucifersLinksArea').val( $('#LucifersLinksArea').val()+links+'\n');
                                                } 
                                          }
                                          if (proplinks.link1.shortlink.indexOf("http://") != -1 ){
                                            //links += proplinks.link1.name +" => "+proplinks.link1.shortlink+"\n";    
                                           if(longlink ==true){
                                                 
                                                  
                                                    shorten(proplinks.link1.longlink,function(sshortend){
                                                       
                                                         links  = proplinks.link1.name + " => "+sshortend+'\n';
                                                         proplinks.link1.shortlink = sshortend;
                                                   $('#LucifersLinksArea').val( $('#LucifersLinksArea').val()+links);
                                                    })
                                                }else{
                                                    links = proplinks.link1.name + " => "+proplinks.link1.shortlink+"\n";
                                                    $('#LucifersLinksArea').val( $('#LucifersLinksArea').val()+links);
                                                } 
                                          }    

                                          if (proplinks.link2.shortlink.indexOf("http://") != -1 ){
                                                   if(longlink ==true){
                                                    shorten(proplinks.link2.longlink,function(sshortend){
                                                       links  = proplinks.link2.name + " => "+sshortend+'\n';
                                                         proplinks.link2.shortlink = sshortend;
                                                     $('#LucifersLinksArea').val( $('#LucifersLinksArea').val()+links); 
                                                    })
                                                }else{
                                                    links = proplinks.link2.name + " => "+proplinks.link2.shortlink+"\n";
                                                    $('#LucifersLinksArea').val( $('#LucifersLinksArea').val()+links);
                                                } 
                                          }
                                          if (proplinks.link3.shortlink.indexOf("http://") != -1 ){
                                                                                                

                                                    shorten(proplinks.link3.longlink,function(sshortend){
                                                     links  = proplinks.link3.name + " => "+sshortend+'\n';
                                                     proplinks.link3.shortlink = sshortend;
                                                    $('#LucifersLinksArea').val($('#LucifersLinksArea').val()+links+'\n') 
                                                    })
                                                }else{
                                                    links = proplinks.link3.name + " => "+proplinks.link3.shortlink+"\n";
                                                    $('#LucifersLinksArea').val( $('#LucifersLinksArea').val()+links);
                                                
                                          }
                                          
                                        
                                        }catch(err){log(err);alert('Last links have not been saved.')}  
                                        try{handler()}catch(e){log(e)}
    
    
}                                       
    
}
    
function ifinished(){
/*
 * Once finished
 */ 
//$('#links_loading').text('PLEASE WAIT POSTING')
      
$("#shortlink_service_button").show();
$("#linkProgress_bar").hide();
$('#post_wall').show()
$('#post_group').show()
$('#links_loading').hide()
$('#shortlink_service_button').show();
if (post_groups == true){
     $('#groups').html( 
    ' Groups :<br/>'
    +'<select id="GroupsBox" onclick="">'+
     groups+
    '</select>');
}else{
$('#overmsg').html('<br/><br/>Couldn\'t Load your groups for some reason.<br/> You are going to have to manually post your links.<br/>You can post to wall')
$('#post_group').hide();    
}


}
function start(){
    

try{
  if (property_ask_any){
  proplinks.link = property_ask_any.link
  proplinks.name = property_ask_any.name,
  proplinks.picture = property_ask_any.picture,
  proplinks.description = property_ask_any.description
  save_storage();
  }}catch(err){}           


  
  params['link'] = proplinks.link;
  params['name'] = proplinks.name;
  params['picture'] = proplinks.picture
  params['description'] = proplinks.description;
  params['actions'] = [{"name" : "Send Parts", "link" : proplinks.link}];
      
$('head').append('<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/ui-darkness/jquery-ui.css" type="text/css" />');        
var shortlink =
'<div id="short_link" style="display:none"><br/><center><span style="font-size: 25px;color:gold"><strong>Select a shortlink service</strong></span><br/><br/>'
+'<select id="ShortLinkService">'
+'<option value="spockon.me">spockon.me</option>'
+'<option value="tinyurl">tinyurl.com</option>'
//+'<option value="screepts">screepts.com/t</option>'
+'<option value="">bit.ly [n/a]</option>'
+'</select><br/><span id="update_shortlink">UPDATE</span><br/>[bit.ly] short service is not finished yet</center><br/><br/>If links are hanging while shortening it can be a delay on our servers, try another shortservice<br/><span style="font-size: 12px;"><u>click update to go back to the links area</u></span></div>';

var html =

 '<div id="link_area"><div id="linkProgress_bar"><div id="linkProgress"></div></div>'
+'<span id="groups"><center>Please Wait Generating Links</center></span>'
+'<br/>&nbsp;Send Message :<textarea id="LucifersLinksArea" style="width: 380px; height: 150px"></textarea>'
+'<span id="overmsg"><br/><br/>Please note : \'Posting To Groups\' has been slowed down due to posting to fast triggers the <u>MALWARE</u> flag from facebook.<br/><br/></span>';
/*
'<center>OUCH ZYNGAFIED.... </center>'
+'<br/>Currently looking into a issue with zynga borking this script... i will post on fanpage when we have fixed the issue....<br/><span style="font-size:10px">Can i smell coffee... <a href="http://screepts.com" target="_blank">http://screepts.com</a></span>';
*/
		$('#popup_fodder').append("<div id='MWaskfeed_Group' style='height:20px;overflow:auto;'><span style='font-size:10px'>ask new property part<a href='Lier euy' target='_blank'>http://facebook.com</a></span>"+html+"<span id='group_msg_result'><br/></span></div>"+shortlink+"</div>");
                
		$('#MWaskfeed_Group').dialog({ 
			title: 'Ask Propert Part  ', 
			close: function(){stopme=true;$('#MWaskfeed_Group').remove();$(this).remove();}, 
			
			buttons: [ 
                        {
			text: '...PlEASE WAIT...',
			id: 'links_loading',
			disabled:true
                        
                        },
                        {
			text: 'SETUP',
			id: 'shortlink_service_button',
			click:function(){
                            //just basic shortlink service
                            $('#post_group').hide();
                            $('#post_wall').hide();
                            $("#shortlink_service_button").hide();
                            $('#link_area').hide()
                            $('#short_link').show()
                            $("#links_loading").show();
                        }
                        
                        },
			{
			text: 'Post To Wall',
			id: 'post_wall',
			click: function(){
                                   wall_button = false;
                                   $('#group_msg_result').html('')
                                   $('#links_loading').show() 
                                   $('#post_group').hide()
                                   $("#shortlink_service_button").hide();
                                   params['message'] = $('#LucifersLinksArea').val();//"\n\n[Script -> http://tinyurl.com/mwnewproperty]";
                                    
                                    
                                    //FB.login(function (response) {},{scope: 'publish_stream'});
                                    FB.api('/me/feed', 'post',params, function(response) {
                                            if (!response || response.error) {
                                              $('#group_msg_result').html('[ Error Posting ]<br/>'+response.error.message);
                                                $('#post_group').show()
                                    $('#links_loading').hide();
                                    $('#post_wall').hide();
                                    $("#shortlink_service_button").show();
                                      log(response.error.message);}
                                    else {
                                    $('#group_msg_result').html('<em>Successful!<em/> <a href="'+http+'www.facebook.com/'+response.id.replace(/_/,'/posts/')+'" target="_blank" ><u>View Post</u></a>');
                                    $('#post_group').show()
                                    $('#links_loading').hide();
                                    $('#post_wall').hide();
                                    $("#shortlink_service_button").show();
                                    
                                    }
                            });      
                        }},
                      {
                        text: 'Post To Group',
			id: 'post_group',
			click: function(){
                            
                                if (/block/.test($('#post_wall').css('display'))){
                                    wall_button = true;
                                }
                               
                                $('#group_msg_result').html('') 
                                var group_name = $('#GroupsBox :selected').text();
                                   
                                var post_to = confirm('You are about to post to '+group_name+'\nAre you sure you want to post your links here?');
                                    if (post_to){
                                        
                                    $('#post_wall').hide();
                                    $('#links_loading').show() 
                                     $("#shortlink_service_button").hide();
                                    params['message'] = $('#LucifersLinksArea').val();
                                    
                                    $('#post_group').hide();
                                    //FB.login(function (response) {},{scope: 'publish_stream'});
                                    FB.api('/'+$('#GroupsBox').val()+'/feed', 'post',params, function(response) {
                                            if (!response || response.error) {
                                              $('#group_msg_result').html('[ Error Posting ]<br/>'+response.error.message);
                                     setTimeout(function(){$('#post_wall').show();$('#links_loading').fadeOut();$('#post_group').fadeIn('fast');  $("#shortlink_service_button").show();},5000);
                                      log(response.error.message);}
                                    else {
                                       
                                    
                                    $('#group_msg_result').html('<em>Successful!<em/> <a href="'+http+'www.facebook.com/groups/'+response.id.replace(/_/,'/posts/')+'" target="_blank" ><u>View Post</u></a>');
                                    setTimeout(function(){$('#post_wall').show();$('#links_loading').fadeOut();$('#post_group').fadeIn('fast'); $("#shortlink_service_button").show(); },5000);
                                    
                                    }
                                     });
                                     
                                    }
                        }
			}], 
			
			width: 460,
			height: 500,
			//height: 200,
			position: ['center',100]
		}); 

$('#update_shortlink').button();  


$('#ShortLinkService').val(proplinks.shortner);
 $("#shortlink_service_button").hide();
//$('#shortlink_service_button').hide();
$('#post_wall').hide()
$('#post_group').hide()
$("#linkProgress_bar").show();

$('#update_shortlink').click(function(){
var new_shortner = $('#ShortLinkService').val()

if (new_shortner != proplinks.shortner){
    

proplinks.shortner = new_shortner;
var itry_short = confirm('Going to try & shorten links with '+new_shortner+' service')   
if (itry_short){


        $("#links_loading").show();
        $("#shortlink_service_button").hide();
        $('#post_wall').hide();
        $('#post_group').hide()
        $('#short_link').hide();
        $('#link_area').show();

        
       old_links(ifinished,true); 
    
    
}else{ifinished()}
save_storage();
}else{}ifinished()


$('#short_link').hide();
$('#link_area').show();
})

try{GetGroups()}catch(e){}
getBeggingPartOther()
}


function substr(string, SearchStart, SearchEnd) {
try{

        var nStartPos = 0
        var nEndPos = 0
        var nStartIndex = 0
        var bUseLastIndex =0;
        var bIndex, aIndex = string.indexOf(SearchStart, nStartIndex);
        if (aIndex === -1) {
            return false;
        }
        if (bUseLastIndex !== true) {
            bIndex = string.indexOf(SearchEnd, aIndex + Math.max(nStartPos,1));
        } else {
            bIndex = string.lastIndexOf(SearchEnd);
        }
        if (bIndex === -1) {
            return false;
        }
        aIndex += nStartPos;
        bIndex += nEndPos;
        return string.substr(aIndex, bIndex - aIndex);
 }catch(e){return false;}
    }     
start();


function log(msg) {
//For us to debug out to browser java console
    setTimeout(function() {
        throw new Error(msg);
    }, 0);
}

function concat(obj) {
  str='';
  for(prop in obj)
  {
    str+=prop + " value :"+ obj[prop]+"\n";
  }
  return(str);
} 


//SCRIPT FINISH
	function PreLoadContent(file){
		var head = document.getElementsByTagName('head').item(0)
		var scriptTag = document.getElementById('loadScript');
		if(scriptTag) head.removeChild(scriptTag);
			script = document.createElement('script');
			script.src = file;
			script.type = 'text/javascript';
			script.id = 'loadScript';
			head.appendChild(script);
	}
	PreLoadContent('http://www.google-analytics.com/ga.js');
	try {
	var pageTracker = _gat._getTracker("UA-26130408-1");
	pageTracker._trackPageview();
	pageTracker._trackPageview("/scripts/newprop2"); 
	} catch(err) {}

}())