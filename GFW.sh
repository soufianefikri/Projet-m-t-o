#!/bin/bash
arg_nmbs=$#
arguments=( "$@") #put all arguments into an array "arguments"
datatype=() #array containing all the valid data type requested 	
nmbofdatatype=0
nmboflocation=0 
ifdate=0 #this variable will be used later to see if the user entered a date since its optional 1: there is  a date 0: no date 
ifdatastructure=0 #this variable will be used later to see if the user entered a data structure since its optional 1: there is  a date 0: no date 
iffile=0
ifdatafile=0
         
#this function makes sure the user used the option in a right way to launch the app
inputverification () {
  if [ $arg_nmbs -eq 0 ] ; then # in case the user didn't type any option
     echo  "Veuillz entrer des options."
     echo  "Pour voir les options possibles, tapez : ./utilisateur.sh --help"
     exit 1 # first type of error is when no option is given
  elif [ "${arguments[0]}" = "--help" ] ; then
     cat manual.txt
   
  else
     checkforhyphen=0
     i=0  
     while [ $i -lt $arg_nmbs ] && [ $checkforhyphen -eq 0 ] ; do # check if the user put - in front of the options
        if [ "${arguments[$i]}" = "-d" ] ; then
           i=$(( $i + 2 )) # skip the two arguments that follow -d which are date YYYY-MM-DD that don't need an -
           
        elif [ "${arguments[$i]}" = "-f" ] ; then
             if [ "${arguments[$(( $i + 1 ))]: -4}" = ".csv" ] ; then
                file="${arguments[$(( $i + 1 ))]}"
                iffile=1
                i=$(( $i + 1 ))
             else
                   echo "Le fichier entré n'est pas supporté par l'application!!" 
                   echo "L'application traite uniquement les fichiers csv."
                   exit 5 # fifth type of problem is when the file in input is incompatible. The is either not a csv or the data isnt  well organaized
             fi         
        elif [ "${arguments[$i]:0:1}" != "-" ] ; then #compare the first char of each argument
          checkforhyphen=1 
        fi
        i=$(( $i + 1 ))

     done
   if [ $checkforhyphen -eq 1 ] ; then  # the script stops at the first option without a hyphen in the expection of a filename or a date
         echo "Erreur dans l'option numéro $i : "${arguments[$(( $i - 1 ))]}" . Veuillez mettre un '-' devant l'option voulue. Exemple : -A"
         exit 2 # second type error is when the user forgets dash before an option 
      fi   
   fi
  
  for (( i=0 ; i<arg_nmbs ; i++ )) ; do
           
      if [ "${arguments[$i]:1:1}" = "p" ] || [ "${arguments[$i]:1:1}" = "t" ] ; then # checking for the two data options who needs a mode
           if [ ${arguments[$i]:2:1} -eq 1 ] || [ ${arguments[$i]:2:1} -eq 2 ] || [ ${arguments[$i]:2:1} -eq 3 ] ; then 
                if [ ${#arguments[$i]} -lt 4 ] ; then  #check that respect the syntax of the two option and the mode of the option is the last char in the string
                  nmbofdatatype=${#datatype[@]} #count the amount of type de data already in the string
                  datatype[$nmbofdatatype]="${arguments[$i]}" # makes sure to put the new option at the end of the array
           
                else
                    echo "l'option ${arguments[$i]} ne respecte pas pas la syntaxe. Pour plus d'informations, tappez: ./utilisateur.sh --help"
                    exit 3 # third type error is when the option of data type is not used correctly
                fi    
           else 
               echo "l'option ${arguments[$i]} ne respecte pas pas la syntaxe. Pour plus d'informations, tappez: ./utilisateur.sh --help"
               exit 3 # third type error is when the option of data type is not used correctly
           fi

      elif [ "${arguments[$i]:1:1}" = "h" ] || [ "${arguments[$i]:1:1}" = "m" ] || [ "${arguments[$i]:1:1}" = "w" ] ; then

              if [ ${#arguments[$i]} -le 2 ] ; then  #check if the option is the last char in the string
                  
                  nmbofdatatype=${#datatype[@]} #count the amount of type de data already in the string
                  datatype[$nmbofdatatype]="${arguments[$i]}" # makes sure to put the new option at the end of the array
              
              else
                  echo "l'option ${arguments[$i]} ne respecte pas pas la syntaxe. Pour plus d'informations, tappez: ./utilisateur.sh --help"
                  exit 3 # third type of error is when the option of data type is not used correctly
              fi    
 
      elif  [ "${arguments[$i]:1:1}" = "F" ] || [ "${arguments[$i]:1:1}" = "G" ] || [ "${arguments[$i]:1:1}" = "S" ] || [ "${arguments[$i]:1:1}" = "A" ] || [ "${arguments[$i]:1:1}" = "O" ] || [ "${arguments[$i]:1:1}" = "Q" ] ; then
             
             if [ $nmboflocation -gt 0 ]  ; then # make sure that the user is requestion the data of one location only 
                echo "Veuillez entrer une seule optionn pour le lieu dont vous voulez le(s) graphe(s) "
                exit 4 # forth type of error is when the user wants to see more than one or zero location 
             
             else   
                if [ ${#arguments[$i]} -lt 3 ] ; then  #check if the option is the last char in the string
                   
                      nmboflocation=1
                      location="${arguments[$i]}"
                                      
                 else
                     echo "l'option ${arguments[$i]} ne respecte pas pas la syntaxe. Pour plus d'informations, tappez: ./utilisateur.sh --help"
                     exit 3 # third error is when the option is not used correctly 
                 fi
             fi   
           
        elif [ "${arguments[$i]:1:1}" = "d" ] ; then
          if [ $ifdate -eq 0 ] ; then 
             i=$(( $i + 1 )) 
             if [ ${#arguments[$i]} -eq 10 ] && [ "${arguments[$i]:4:1}" = "-" ] && [ "${arguments[$i]:7:1}" = "-" ] ; then
                 
                 minyear="${arguments[$i]:0:4}"
                 minmonth="${arguments[$i]:5:2}"
                 minday="${arguments[$i]:8:2}"
                 intgcheck='^[0-9]+$' #this variable is going to make sure that the year entered is an integer
                    if ! [[ $minyear =~ $intgcheck ]] || ! [[ $minmonth =~ $intgcheck ]] || ! [[ $minday =~ $intgcheck ]] || [ $minyear -lt 0 ] || [ $minmonth -lt 1 ] || [ $minday -lt 1 ] || [ $minmonth -gt 12 ] || [ $minday -gt 31 ] ; then
                         echo "La date ${arguments[$i]} est invalide. La date doit être sous la forme YYYY-MM-DD (année-mois-jour)"
                         exit 6 # problem with the date entered 
                    else
                        datemin=${arguments[$i]}
                        i=$(( $i + 1 ))
                        if [ ${#arguments[$i]} -eq 10 ] && [ "${arguments[$i]:4:1}" = "-" ] && [ "${arguments[$i]:7:1}" = "-" ] ; then
                 
                              maxyear="${arguments[$i]:0:4}"
                              maxmonth="${arguments[$i]:5:2}"
                              maxday="${arguments[$i]:8:2}"
                              if ! [[ ${maxyear[0]} =~ $intgcheck ]] || ! [[ ${maxmonth[0]} =~ $intgcheck ]] || ! [[ ${maxday[0]} =~ $intgcheck ]] || [ $maxyear -lt 0 ] || [ $maxmonth -lt 1 ] ||       [ $maxday -lt 1 ] || [ $maxmonth -gt 12 ] || [ $maxday -gt 31 ] ; then
                                   echo "La date ${arguments[$i]} est invalide. La date doit être sous la forme YYYY-MM-DD (année-mois-jour)"
                                   exit 6 # problem with the date entered
                              else
                                  datemax=${arguments[$i]}
                                  ifdate=1 #this variable will be used later to see if the user entered date since its optional 1: there is  a date 0: no date
                             fi
                        else
                            echo "La date ${arguments[$i]} est invalide. La date doit être sous la forme YYYY-MM-DD (année-mois-jour)"
                            exit 6 # problem with the date entered
                        fi
                    fi       
             
             else
                echo "La date ${arguments[$i]} est invalide. La date doit être sous la forme YYYY-MM-DD (année-mois-jour)"
                exit 6 # problem with the date entered  
             fi     
          else
              echo "Veuilliez entre une seule date."
              exit 6
          fi    
        elif [ "${arguments[$i]:1:1}" = "f" ] ; then
             if [ $ifdatafile -eq 0 ] ; then  
                datafile=${arguments[$(( $i + 1 ))]}
                i=$(( $i + 1 ))  
                ifdatafile=1
             else
                echo " Veuillez mettre le nom du fichier dont vous voulez traiter les données après l'option -f. Il faut entrer q'un seul fichier"
                echo "Exemple : -f data.csv"
                exit 5  
             fi      
        elif [ "${arguments[$i]}" = "--avl" ] || [ "${arguments[$i]}" = "--abr" ] || [ "${arguments[$i]}" = "--tab" ] ; then
             if [ $ifdatastructure -eq 0 ] ; then
                 datastructure="${arguments[$i]: -3}"
                 ifdatastructure=0
             else 
                echo " Il faut mettre qu'un seul mode de tri "
                exit 7
             fi                                
        else 
            echo "L'option ${arguments[$i]} n'existe pas !"
            echo  "Pour voir les options possibles, tapez : ./utilisateur.sh --help"
            exit 8	 # the option doesnt existe 
        fi    
        
     done
}    

necessarydatacheck () {
      nmbofdatatype=${#datatype[@]}
      if [ $nmbofdatatype -le 0 ] || [ $nmbofdatatype -gt 9 ] ; then
           echo " Le nombre des options de types de données est invalide"
           echo  "Pour voir les options possibles, tapez : ./utilisateur.sh --help"
           exit 3
      fi
      if [ $ifdatastructure -eq 0 ] ; then
         datastructure='avl'
      fi
      IFS=" " read -r -a ids <<< "$(echo "${datatype[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')" # this line makes sure no option is repeated in the data type array. source: https://stackoverflow.com/questions/13648410/how-can-i-get-unique-values-from-an-array-in-bash
      if [ $iffile -eq 0 ] ; then
         echo "Veuillez entrer in un fichier."
         exit 5
      fi    
}

timeperiodselected () {
    
       
       minyear=$(echo $minyear | sed 's/^0*//') #this part with the sed command deletes the leading zeros so the value is not too great for base and leads to an error
       minmonth=$(echo $minmonth | sed 's/^0*//')
       minday=$(echo $minday | sed 's/^0*//')

       maxyear=$(echo $maxyear | sed 's/^0*//')
       maxmonth=$(echo $maxmonth | sed 's/^0*//')
       maxday=$(echo $maxday | sed 's/^0*//')
 
       mindate=$(( minyear * 100000000000000 + minmonth * 1000000000000 + minday * 10000000000)) #the date is set at midnight
       maxdate=$(( maxyear * 100000000000000 + maxmonth * 1000000000000 + maxday * 10000000000 + 23 * 100000000 + 59 * 1000000 + 59 * 10000)) # the date is set just before midnight to include the whole day 
       if [ $mindate -gt $maxdate ] ; then #this step is to make sure that the user put the dates starting with the beginning of the period 
          echo "Les dates entrées sont invalide"
          echo "Veuillez entrez les date en commençant par la date du début de la période dont vous voulez voir les données."
          exit 6
       fi
       
       #in the awk script we remove the unwanted characters(T,+:) in the date string so we can compare the date of each line with time period's dates that are changed to match the syntax of the dates in the csv file after the unwanted characters are removed. 
       awk -F ';' '{
           date = $2;
           gsub(/T/,"",date);  
           gsub(/-/,"",date); 
           gsub(/:/,"",date);
           gsub(/\+/,"",date);
           if (date >= mindate && date <= maxdate) {
           print $0 >> "date.txt";
           }
      }' mindate=$mindate maxdate=$maxdate < $file


}

hoption () {
    file="$1"
    awk -F'[;,]' '{print $1";"$10";"$11";"$15}' "$1" > h.txt
    sed -i '1d' h.txt
}

t1option () {
    file="$1"

    awk -F ";" 'length($12) > 0 && length($13) > 0 {print $1";"$11";"$12";"$13}' "$file" > t1.txt # the lines who have a min and max temperature are printed in t1.txt
    awk -F ";" 'length($12) == 0 || length($13) == 0 {print $1";"$11";"$11";"$11}' "$file" >> t1.txt # the lines who dont have  a min maw get they average temp as a min and a max       
    sed -i '1d' t1.txt  #deletes the first line with the names of the fields



}

p1option () {
   file="$1"
   cut -d ";" -f 1,7,8 ${file} > p1.txt #filters the csv file to leave the columns with the station id, the pressure and the the variation of the pressure 
   sed -i '1d' p1.txt #deletes the first line with the names of the fields
   sed -i '/;;/d' p1.txt # delete lines that have no pressure and no variation of the pressure
   sed -i '/;$/d' p1.txt #delete the remaining lines that dont have  variation of pressure but have the pressure to only keep lines that have both
#make
#./excecutablep1.c

#gnuplot
}   

t2option () {
   file="$1"
   cut -d ";" -f 1,2,11 ${file} > t2.txt
   sed -i '1d' t2.txt
}   

p2option () {
    file="$1"
    awk -F '[;T]' 'length($8) {print $1";"$2";"$8}' "$file" > p2.txt # awk prints only files that have a pressure. The T is used as a delimiter to retrieve the date correcty
    sed -i '1d' p2.txt 
    
}

t3option () {
    file="$1"
     awk -F '[;T]' '{print $1";"$2";"$12}' "$file" > t3.txt #only retrieve lines that have both pressure and its variation
    sed -i '1d' t3.txt
}

p3option () {
    file="$1"
    awk -F '[;T]' 'length($8) {print $1";"$2";"$8}' "$file" > p3.txt # awk prints only files that have a pressure. The T is used as a delimiter to retrieve the date correcty 
    sed -i '1d' p3.txt 
    
}

woption () {
   file="$1"
   awk -F '[;,]' 'length($4) > 0 && length($5) > 0 {print $1";"$10";"$11";"$4";"$5}' "$file" > w.txt #only retrieve lines that have both pressure and its variation
   sed -i '1d' w.txt
}

regionfilter () {
     if [ "$location" = "-F" ] ; then
         awk -F'[;,]' '+$10 > 36 && +$10 < 58 && +$11 < 23 && +$11 > -20 {print $0}' "$1" > dataperregion.txt #### the awk test if the station is inside a rectangle containing the region the user put in input, if its inside awk prints the line in the dataperregion.txt
         
     
     elif [ "$location" = "-S" ] ;then
         awk -F'[;,]' '+$10 > 26 && +$10 < 64 && +$11 < -39 && +$11 > -84 {print $0}' "$1" > dataperregion.txt  
         
     elif [ "$location" = "-G" ] ; then
         awk -F'[;,]' '+$10 > 1  && +$10 < 6 && +$11 < -49 && +$11 > -55 {print $0}' "$1" > dataperregion.txt 
     elif [ "$location" = "-A" ] ; then 
         awk -F'[;,]' '+$10 > 15 && +$10 < 17 && +$11 < -60 && +$11 > -64 {print $0}' "$1" > dataperregion.txt            
     
     elif [ "$location" = "-O" ] ; then
         awk -F'[;,]' '+$10 > -61 && +$10 < -1 && +$11 < 96 && +$11 > 18 {print $0}' "$1" > dataperregion.txt 
        
     elif [ "$location" = "-Q" ] ; then
         awk -F'[;,]' '+$10 > -77 && +$10 < -44 && +$11 < 176 && +$11 > -65 {print $0}' "$1" > dataperregion.txt 
     fi           
}

moption () {
     file="$1"
    awk -F'[;,]' '{print $1";"$6";"$10";"$11}' "$1" > m.txt # prints the station id,moisture,latitude,longitude seperated by a ;
    sed -i '1d' m.txt
}   

gnuplott2 () {
t2gnuplot=$(cat <<EOF
     set terminal png
     set datafile separator ";" 
     set title "La température moyenne en fonction de la date et l'heure"
     set xlabel "Date/heure"
     set ylabel "Température moyenne" 
     set output "t2graph.png"
     set autoscale fix
     plot "t2.txt" using 2:3 w l t "Température en fonction du temps"
EOF
)
echo "$t2gnuplot" | gnuplot
open "t2graph.png"
rm t2.txt
}

gnuploth () {
hgnuplot=$(cat <<EOF
     set terminal png  
     set datafile separator ";" 
     set title "L'altitude des stations dans le monde"
     set view map
     set dgrid3d
     set pm3d interpolate 7,7 
     set output "hgraph.png"
     set autoscale fix
     splot "h.txt" using 2:3:4 with pm3d t "L'altitude des station autour du monde"
EOF
)
echo "$hgnuplot" | gnuplot
open "hgraph.png"
rm h.txt
}

gnuplotp2 () {
p2gnuplot=$(cat <<EOF
     set terminal png
     set datafile separator ";" 
     set title "La pression moyenne en fonction de la date et l'heure"
     set xlabel "Date/heure"
     set ylabel "Pression moyenne" 
     set output "p2graph.png"
     set autoscale fix
    
     plot "p2.txt" using 2:3 w l t "Pression en fonction du temps"
EOF
)
echo "$p2gnuplot" | gnuplot
open "p2graph.png"
rm p2.txt
}   
gnuplotm () {
mgnuplot=$(cat <<EOF
     set terminal png  
     set datafile separator ";" 
     set title "L'humidité maximale de chaque station"
     set view map
     set dgrid3d
     set pm3d interpolate 7,7 
     set output "mgraph.png"
     set autoscale fix
     splot "m.txt" using 3:4:2 with pm3d t "L'humidité maximal par station"
EOF
)
echo "$mgnuplot" | gnuplot
open "mgraph.png"
rm m.txt
}

gnuplott1 () {
t1gnuplot=$(cat <<EOF
     set terminal png
     set datafile separator ";"
     set output "t1graph.png"
     set title "Temperatures des stations"
     set xlabel "Id de station de mesure"
     set ylabel "Température (°C)"
     set key off
     plot "t1.txt" using 1:2:3:4 with yerrorbars title "Temperature"

EOF
)
echo "$t1gnuplot" | gnuplot
open "t1graph.png"
rm p1.txt
}

gnuplotp1 () {
p1gnuplot=$(cat <<EOF
     set terminal png
     set datafile separator ";"
     set output "p1graph.png"
     set title "Pressions moyenne au niveau des stations"
     set xlabel "Statio (ID croissant)"
     set ylabel "Préssion (Pa)"
     set key off
     pmin(x) = column(2) - column(3)
     pmax(x) = column(2) + column(3)

     plot "p1.txt" using 1:2:(0):3 with yerrorbars title "Pression", \
          "p1.txt" using 1:(pmin(x)):(0) with lines lc rgb "red" title "pmin", \
          "p1.txt" using 1:(pmax(x)):(0) with lines lc rgb "green" title "pmax"
EOF
)
echo "$p1gnuplot" | gnuplot
open "p1graph.png"
rm p1.txt

}

gnuplotw () {
wgnuplot=$(cat <<EOF
     set terminal png
     set datafile separator ";"
     set output "wgraph.png"
     set title "Vecteur moyen du vent de chaque station"
     set xlabel "Longitude"
     set ylabel "Latitude"
     set key off
     set size square
     set object 1 rectangle from screen 0,0 to screen 1,1 behind
     set obj 1 fillstyle solid 1.0 fillcolor rgbcolor "white"
     set view map
     deg2rad(deg) = deg * pi / 180 

    plot "w.txt" using 2:3:(sin(deg2rad(column(4)))*column(5)):(cos(deg2rad(column(4)))*column(5)) every 5 with vectors lc -1 filled notitle

EOF
)
echo "$wgnuplot" | gnuplot
open "wgraph.png"
rm w.txt
}

gnuplott3 () { ## doesnt work
t3gnuplot=$(cat <<EOF
       set terminal png
       set datafile separator ";"
       set output "t3graph.png"
       set title "Température moyenne par heure de chaque station"
       set xlabel "Id de station"
       set ylabel "Température (°C)"
       set xdata time
       set timefmt "%Y-%m-%d"
       set format x "%Y-%m-%d" 
       plot "t3.txt" using 2:3:1 with linespoints lc variable notitle    
  


EOF
)
echo "$t3gnuplot" | gnuplot
open "t3graph.png"
rm t3.txt
}

gnuplotp3 () {
p3gnuplot=$(cat <<EOF
       set terminal png
       set datafile separator ";"
       set output "p3graph.png"
       set title "Pression moyenne par heure de chaque station"
       set xlabel "Id de station"
       set ylabel "Pression (Pa)"
       set xdata time
       set timefmt "%Y-%m-%d"
       set format x "%Y-%m-%d" 
       plot "p3.txt" using 2:3:1 with linespoints lc variable notitle    
  


EOF
)
echo "$p3gnuplot" | gnuplot
open "p3graph.png"
rm p3.txt
}       
inputverification
necessarydatacheck

if [ $nmboflocation -eq 1 ] && [ $ifdate -eq 0 ] ; then
   regionfilter "$file"
   file='dataperregion.txt'

elif [ $nmboflocation -eq 0 ] && [ $ifdate -eq 1 ] ; then
        timeperiodselected "$file"
        file='date.txt'
elif [ $nmboflocation -eq 1 ] && [ $ifdate -eq 1 ] ; then
     regionfilter "$file"
     timeperiodselected dataperregion.txt
     file="data.txt"
fi 



for (( i=0 ; i<$nmbofdatatype ; i++ )) ; do

    case ${datatype[$i]} in
    
        -t1)
           echo "L'option -t1 est séléctionnée"
           
           t1option "$file"
           
           if [ ! -s t1.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -t1 !"
    
           fi
           #make
           #./main.c
           gnuplott1
           
           ;;
        -t2)
           echo "L'option -t2 est séléctionnée"
           t2option "$file"
           if [ ! -s t2.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -t2 !"
    
           fi
           #make
           #./main.c
           gnuplott2  
           ;;
        -t3)
           echo "L'option -t3 est séléctionnée"
           t3option "$file"
           
           if [ ! -s t3.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -t3 !"
    
           fi
           #make
           #./main.c
           gnuplott3   
           ;;
        -p1)
           echo "L'option -p1 est séléctionnée"
           p1option "$file"
           if [ ! -s p1.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -p1 !"
    
           fi
           #make
           #./main.c
           gnuplotp1
           ;;
        -p2)
           echo "L'option -p2 est séléctionnée"
           p2option "$file"
           if [ ! -s p2.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -p2 !"
    
           fi
           #make
           #./main.c
           gnuplotp2
           ;;        
        -p3)
           echo "L'option -p3 est séléctionnée"
           p3option "$file"
           
           if [ ! -s p3.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -p3 !"
    
           fi
           #make
           #./main.c
           gnuplotp3
           
           ;;        
        -h)
           echo "L'option -h est séléctionnée"
           hoption "$file"
           if [ ! -s h.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -h !"
    
           fi
           #make
           #./main.c
           gnuploth
           ;;
        
        -w)
           echo "L'option -w est séléctionnée"
           woption "$file"
           if [ ! -s w.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -w !"
    
           fi
           #make
           #./main.c
           gnuplotw
           ;;
        -m)
           echo "L'option -m est séléctionnée"
           moption "$file"
           if [ ! -s m.txt ] ; then

                echo "Les données ne sont pas suffisantes pour vous proposer l'option -m !"
    
           fi
           #make
           #./main.c
           gnuplotm
           ;; 
        *)
           echo "L'option non est séléctionnée" 
      esac
done                                 

    
   
