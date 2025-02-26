/////////////////////////////////////////////////////////////////////////////////////////////////////////	
//var objectPROWIN = new PROWIN();
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
function PROWIN(LEFT,TOP,WIDTH,CANVAS){
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	var defL = '100px';
	var defT = '100px';
	var defW = '200px';
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	this.L = (typeof LEFT !== 'undefined') ? LEFT : defL;
	this.T = (typeof TOP !== 'undefined') ? TOP : defT;
	this.W = (typeof WIDTH !== 'undefined') ? WIDTH : defW;
	this.M = new Array();
	this.V = '1.1';
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// GLOBAL
	newMESG = function(MESG){
		var PW = getPROWIN();
		return PW.addMESG(MESG);
	}
	/*
	// native
	xhr.onloadstart = function(){ newMESG("MESSAGE"); }
	xhr.onloadend   = function(){ delMESG("MESSAGE"); }
	// jquery
	beforeSend: function(jqXHR,settings)              { newMESG("MESSAGE"); },
	complete:   function(jqXHR,textStatus,errorThrown){ delMESG("MESSAGE"); },
	*/
	delMESG = function(MESG){
		var PW = getPROWIN();
		PW.minMESG(MESG);
	}
	/*
	// native + jquery
	var pwid;
	// native
	xhr.onloadstart = function(){ pwid=newMESG("MESSAGE"); }
	xhr.onloadend   = function(){      delMESGbyID(pwid); }
	// jquery
	beforeSend: function(jqXHR,settings)         { pwid=newMESG("MESSAGE"); },
	complete:   function(jqXHR,textStatus,errorThrown){ delMESG(pwid); },
	*/
	delMESGbyID = function(ID){
		var SPAN = document.getElementById(ID);
		if(SPAN){SPAN.remove();}
		var PW = getPROWIN();
		if(PW.M.length==0){delPROWIN();}
	}
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// GLOBAL
	delPROWIN = function(){
		var TOP = document.getElementById('prowinTOP');
		if(TOP){TOP.remove();}
	}
	getPROWIN = function(){
		var TXT = document.getElementById('prowinTXT');
		if(TXT){
			var L = TXT.style.left;
			var T = TXT.style.top;
			var W = TXT.style.width;
			var M = new Array();
			for(var i=0;i<TXT.childNodes.length;i++){
				var iHTML = TXT.childNodes[i].innerHTML;
				M.push(iHTML.substring(7,iHTML.length-13));
			}
			var PW = new PROWIN(L,T,W);
			PW.M = M;
		} else {
			var PW;
			if(objectPROWIN){ PW = objectPROWIN; } else { PW = new PROWIN(defL,defT,defW); }
		}
		return PW;
	}
	getPROPS = function(MESG){
		if(!MESG){var MESG = 'getPROPS:';}
		var PW = getPROWIN();
		PW.showPROPS(MESG);
	}
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// OBJECT PUBLIC
	this.addPROWIN = function(){
		var TOP = document.createElement('DIV');
			TOP.setAttribute('ID','prowinTOP');
			TOP.style.position = 'absolute';
			TOP.style.left = this.L;
			TOP.style.top = this.T;
		document.getElementsByTagName('BODY')[0].appendChild(TOP);
		var ANIME = document.createElement('DIV');
			ANIME.setAttribute('ID','prowinANIME');
			ANIME.style.width = this.W;
		TOP.appendChild(ANIME);
		var BAR = document.createElement('DIV');
			BAR.setAttribute('ID','prowinBAR');
		ANIME.appendChild(BAR);
		var TXT = document.createElement('DIV');
			TXT.setAttribute('ID','prowinTXT');
			TXT.style.width = this.W;
		TOP.appendChild(TXT);
		return TXT;
	}
	this.addMESG = function(MESG){
		var TXT = document.getElementById('prowinTXT');
		if(!TXT){TXT = this.addPROWIN();}
		var SPAN = document.createElement('SPAN');
			SPAN.setAttribute('ID','prowinSPAN'+Math.round(Math.random()*1000000));
			SPAN.innerHTML = '&rtrif;&nbsp;'+MESG+"&nbsp;&hellip;&nbsp;";
			//MESG = SPAN.innerHTML.substring(7,iHTML.length-13);
		TXT.appendChild(SPAN);
		this.M.push(MESG);
		return SPAN.getAttribute('ID');
	}
	this.minMESG = function(MESG){
		var INDEX = this.M.indexOf(MESG);
		if(INDEX>-1){
			var TXT = document.getElementById('prowinTXT');
			if(TXT){
				var iHTML = TXT.childNodes[INDEX].innerHTML;
				if(iHTML.substring(7,iHTML.length-13)==MESG){
					if(TXT.childNodes.length==1){TXT.parentElement.remove();}else{TXT.childNodes[INDEX].remove();}
				}
			}
		}
	}
	this.showPROPS = function(MESG){
		console.log(MESG);
		console.log(MESG+": "+"this.L="+this.L);
		console.log(MESG+": "+"this.T="+this.T);
		console.log(MESG+": "+"this.W="+this.W);
		console.log(MESG+": "+"this.M.length="+this.M.length);
		for(var i=0;i<this.M.length;i++){console.log(MESG+": "+"this.M["+i+"]="+this.M[i]);}
		console.log(MESG+": "+"this.V="+this.V);
	}
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
