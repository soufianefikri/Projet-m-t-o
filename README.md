# Projet-meteo

Bonjour Mr/Mme

On est ravi que vous avez choisi notre application  “Global French Weather”. GFW est une application qui vous permet de voir des graphiques reprèsentants des données métérologiques des territoires français autour du monde.L'application accepte un fichier csv répartie par colonne de la façcon suivante:

ID OMM station;Date;Pression au niveau mer;Direction du vent moyen 10 mn;Vitesse du vent moyen 10 mn;Humidité;Pression station;Variation de pression en 24 heures;Précipitations dans les 24 dernières heures;Coordonnees;Température (°C);Température minimale sur 24 heures (°C);Température maximale sur 24 heures (°C);Altitude;communes (code)

Vous pouvez remarquez que les colonnes sont sépaées pars des ';' au lieu de de ',' comme la plupart des fichiers csv.L'application à en ce momment neuf types de données que vous pouvez représenter en graphiques. Les voici:
Options de la température :

     -t1 -> un graphique sous format barres d’erreur qui montre la température moyenne, maximalle et minimalle de chaque station dans l’ordre croissant des identifiants des stations.

     -t2 -> un graphique sous format ligne simple qui montre la température moyenne qui se fait sur toute les station en fonction de la date et  de l’heure.

     -t3 -> 

Option de la pression :

     -p1 -> un graphique sous format barres d’erreur qui montre la pression moyenne, maximalle et minimalle de chaque station dans l’ordre croissant des identifiants des stations.

     -p2 -> un graphique sous format ligne simple qui montre la pression moyenne qui se fait sur toute les station en fonction de la date et  de l’heure.

Autre :

     -h -> un graphique sous format de carte interpolée et colorée qui montre l’altitude des différents stations dans le monde.

     -w -> un graphique sous format diagramme de vecteur qui montre la direction moyenne et la vitesse moyenne par station.

     -m -> un graphique sous format de carte interpolée et colorée qui montre l'humidité maximale pour chaque station.
     
En ce qui concerne les différentes régions, vous avez les options suivantes:
     -F : (F)rance : France métropolitaine + Corse.
     -G : (G)uyane française.
     -S : (S)aint-Pierre et Miquelon : ile située à l’Est du Canada
     -A : (A)ntilles.
     -O : (O)céan indien.
     -Q : antarcti(Q)ue.

Ressources utilisées:

https://stackoverflow.com/questions/13648410/how-can-i-get-unique-values-from-an-array-in-bash
https://www.youtube.com/watch?v=oPEnvuj9QrI&t=639s
https://linuxhint.com/sed-command-to-delete-a-line/
https://linuxhint.com/remove_characters_string_bash/
https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiCoezrk_n8AhV5VKQEHbgYB7sQFnoECA0QAQ&url=https%3A%2F%2Fwww.digitalocean.com%2Fcommunity%2Ftutorials%2Farrays-in-shell-scripts&usg=AOvVaw2T0Jm1bApVImqg1Jr1Up4B

Pour utiliser l'application, vous devez juste installer tout les fichiers sur le main de ce gethub. Veuillez mettre tous les fichiers récupérés dans un même dossier.


