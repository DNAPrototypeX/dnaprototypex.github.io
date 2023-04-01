var lastyear='An1622';
function CouleurMenu(n) {
if (document.all) {
	/* Determination du n° de l'ancien menu */
	for (i=1;i<=7;i++) {
		lemenu=('menu' + i);
		menu = "parent.menu.document.all." + lemenu + ".style.backgroundColor";
		LaCouleur=eval(menu);
		if (LaCouleur.toUpperCase()=="#66CC99") {
			lastn=i;
			break;
			}
		}
	if (n!=lastn) {
		/* Ancien menu en couleur normale */
		lemenu=('menu' + lastn);
		menu = "parent.menu.document.all."+lemenu+".style.backgroundColor";
		menu+="='#669999'";
		eval(menu);
		/* Nouveau menu en couleur highlight */
		lemenu=('menu' + n);
		menu = "parent.menu.document.all."+lemenu+".style.backgroundColor";
		menu+="='#66CC99'";
		eval(menu);
		}
	}
}
function MouseOver(annee) {
if ((document.all)&&(lastyear!='An'+annee)) { 
	lAnnee="document.all.An" + annee + ".style.backgroundColor='#FFCC00'";
	eval(lAnnee);
	}
}
function MouseOut(annee) {
if ((document.all)&&(lastyear!='An'+annee)) { 
	lAnnee="document.all.An" + annee + ".style.backgroundColor='#FFFFFF'";
	eval(lAnnee);
	}
}

function Click (annee) {
if (document.all) { 
	lAnnee="document.all." + lastyear + ".style.backgroundColor='#FFFFFF'";
	eval(lAnnee);
	lAnnee="document.all.An" + annee + ".style.backgroundColor='#FFCC00'";
	eval(lAnnee);
	lastyear=('An'+annee);
	}
}


