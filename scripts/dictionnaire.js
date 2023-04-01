function dictionnaire (lettre) {
if (parent.entrees) parent.entrees.location='entrees.html#'+lettre;
}
function iconographie(id) {
fenetre=window.open("iconographie.php?id="+id,"Iconographie","scrolbars");
fenetre.focus();
}
