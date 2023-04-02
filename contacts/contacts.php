<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Moli�re : Contacts - La r�f�rence sur l'oeuvre de Moli�re - Actualit�s, Chronologie, Dictionnaire, Oeuvres, Bibliographie, Filmographie</TITLE>
<META NAME="description" lang="fr" CONTENT="Le site de r�f�rence sur l'oeuvre de Moli�re
Ce site, con�u dans un esprit de rigueur scientifique, est destin� � un public large. Aux �tudiants ou lyc�ens qui recherchent des �l�ments d'information relatifs � Moli�re ; aux curieux et aux amateurs de th��tre qui s'int�ressent � notre dramaturge, et aux chercheurs qui y trouveront un certain nombre d'outils de travail commodes.">
<META NAME="keywords" lang="fr" CONTENT="Moli�re, Moliere, Jean-Baptiste Poquelin, th��tre, XVII� si�cle, Louis XIV, illustre th�atre, com�diens, oeuvres, �uvres, textes, pi�ces, com�die, trag�die, oeuvres de Moliere, dramaturgie, th��tre fran�ais, litt�rature classique, livre, repr�sentation, com�die fran�aise, vie de Moli�re, chronologie, biographie, auteur, acteur, troupe, compagnie, mise en sc�ne, portrait, bibliogaphie, filmographie, dictionnaire, avare, theatre, tartuffe, fourberies de scapin, ecrivain, poesie, bourgeois gentilhomme, th��tre moli�re, scapin, Moli�re Biographie, com�die fran�aise, Dom Juan, actualite th��tre, comedia del arte, commedia dell'arte, spectacle,bac fran�ais, theatre, theatre prose, lettres, preparation bac fran�ais">
<meta name="abstract" content="Le site de r�f�rence sur l'oeuvre de Moli�re
Ce site, con�u dans un esprit de rigueur scientifique, est destin� � un public large. Aux �tudiants ou lyc�ens qui recherchent des �l�ments d'information relatifs � Moli�re ; aux curieux et aux amateurs de th��tre qui s'int�ressent � notre dramaturge, et aux chercheurs qui y trouveront un certain nombre d'outils de travail commodes.">
<meta name="reply-to" content="webmaster@toutmoliere.net">
<meta name="category" content="literature">
<meta name="revisit-after" content="30 days">
<meta name="identifier-url" content="">
<meta name="robots" content="index, follow">
<meta name="distribution" content="global">
<META NAME="Author" CONTENT="PHENIX Ing�nierie Informatique - PEZENAS">
<link  href="../styles/styles.css" rel="StyleSheet" type="text/css">
<link  href="../styles/contact.css" rel="StyleSheet" type="text/css">
<script type="text/javascript">
function checkMail(champ) {
	var valid = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@";
	var ok = "yes";
	var temp;
	for (var i=0; i<40; i++) 
	{	
		temp = "" + champ.value.substring(i, i+1);
		if (valid.indexOf(temp) == -1) {
			ok = "no";
		}
		if (ok == "no") {
			champ.value = champ.value.substring(0, i);
		}
	}
}
function verifMail() {
	a = document.contact.email.value;
	testm = false ;
	for (var j=1 ; j<(a.length) ; j++) {
		if (a.charAt(j)=='@') {
			if (j<(a.length-4)){
				for (var k=j ; k<(a.length-2) ; k++) {
					if (a.charAt(k)=='.') {
						testm = true;
					}
				}
			}
		}
	}
	if (testm==false) {
		alert('Votre adresse e-mail est incorrecte.');
		return false;
	}
	return true;
}
</script>
</HEAD>
<BODY CLASS=Corps MARGINHEIGHT=20 MARGINWIDTH=20>
<DIV CLASS=intro>CONTACTS<BR></DIV>
<BR><BR>
<P CLASS=message>Pour nous envoyer un message, poser une question, nous faire part de vos remarques,<BR>
remplissez le formulaire ci-dessous.</P> 
<TABLE BORDER=3 BGCOLOR=#FFCC66 CELLSPACING=0 CELLPADDING=20 ALIGN=CENTER STYLE="border-color:#990000">
<TR><TD>
<FORM name="contact" ACTION=envoie.php METHOD="Post" onSubmit="return verifMail();">
<TABLE CLASS=rubrique>
<TR><TD><B>Pr�nom :</B></TD><TD><INPUT TYPE=text NAME=prenom SIZE=40 MAXLENGTH=40  CLASS=rubrique></TD></TR>
<TR><TD><B>Nom :</B></TD><TD><INPUT TYPE=text NAME=nom SIZE=40 MAXLENGTH=40  CLASS=rubrique></TD></TR>
<TR><TD><B>E-mail :</B></TD><TD><INPUT TYPE=text NAME=email SIZE=40 MAXLENGTH=40  onKeyUp="checkMail(this)" onBlur="checkMail(this)"  CLASS=rubrique></TD></TR>
<TR><TD COLSPAN=2><B>Message :</B><BR><TEXTAREA NAME=message COLS=33 ROWS=5  CLASS=rubrique></TEXTAREA></TD></TR>
</TABLE>
<P ALIGN=CENTER CLASS=rubrique><B>Destinataire :</B></P>
<TABLE WIDTH="100%">
<TR ALIGN=CENTER><TD><INPUT TYPE=submit NAME="destinataire" VALUE="R�daction" CLASS=bouton></TD><TD><INPUT TYPE=submit NAME="destinataire" VALUE="Webmaster" CLASS=bouton></TD></TR>
</TABLE>
</FORM>
</TD></TR>
</TABLE>
<script type="text/javascript" src="stats/php-stats.js.php"></script><noscript><img src="stats/php-stats.php" border="0" alt=""></noscript></body>
</HTML>
