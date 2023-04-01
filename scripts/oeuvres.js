function Mark(n) {
for (i=1;i<=MaxMark;i++) {
	LaMarque=eval("document.images['Mark"+i+"']");
	if (i==n) LaMarque.src="../../images/marky.gif";
	else LaMarque.src="../../images/markw.gif";
	}
}

function menu (n) {
if (n)
	document.location.href="menu"+n+".html";
else
	document.location.href="menu.html";
}

function dico(mot) {
fenetre=window.open("../../dictionnaire/"+mot+".html","Dictionnaire","height=500,width=400,scrollbars");
fenetre.focus();
}

function diconote(mot) {
fenetre=window.open("../dictionnaire/"+mot+".html","Dictionnaire","height=500,width=400,scrollbars");
fenetre.focus();
}

function notes(num) {
note=window.open("../note.php?oeuvre="+oeuvre+"&note="+num,"Note","height=250,width=400,scrollbars");
note.focus();
}
function iconographie(id) {
fenetre=window.open("../iconographie.php?id="+id,"Iconographie","scrolbars");
fenetre.focus();
}
