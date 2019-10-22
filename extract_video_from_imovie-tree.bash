#!/bin/bash

RepVideo="/Volumes/4TOMacMini/Films/iMovie Events.localized/"
RepDest="VideoKarineJan/"

BadRep="iMovie Cache Data"
AvecRepertoire=1

export ordre=1

function AfficheTravail
{
	# Motifs : | / - \ | / - \

	#printf "ordre=($ordre)"

	if [[ $ordre == 9 ]]
	then
		ordre=1
	fi

	case $ordre in
		1)
			printf "\r|" ;;
		2)
			printf "\r/" ;;
		3)
			printf "\r-" ;;
		4)
			printf "\r\\" ;;
		5)
			printf "\r|" ;;
		6)
			printf "\r/" ;;
		7)
			printf "\r-" ;;
		8)
			printf "\r\\" ;;
	esac

	ordre=$(( ++ordre ))
}

# fonction qui test la taille du fichier
function TestTaille
{
	fichier="$1"
	exit_code=1

	taille=$(du "$fichier" | awk -F"\t" '{ print $1 }')

	if [[ $Debug -gt 1 ]]; then printf "[Debug(2)] taille $fichier = $taille\n"; fi

	if [[ $taille -lt 9 ]]
	then
		if [[ $Debug -gt 1 ]]; then printf "[Debug(2)] $fichier non retenu car trop petit\n"; fi
	else
		exit_code=0
	fi

	if [[ $Debug -gt 1 ]]; then printf "[Debug(2)] code retour taille=$exit_code\n"; fi

	return $exit_code
}
		
if [[ $1 != "" ]]
then
	if [[ $1 < 3 ]]
	then
		Debug=$1
		printf "[Debug($Debug)]"
	else
		Debug=2
		printf "[Debug($Debug)]"
	fi
else
	Debug=0
fi

if [[ $Debug > 1 ]]; then printf "[Debug(2)] Demarrage\n"; fi

if [[ $Debug > 1 ]]; then printf "[Debug(2)] RepVideo = $RepVideo\n"; fi

for i in $(ls "$RepVideo")
do
	if [[ $Debug > 0 ]]; then printf "[Debug(1)] Titre Sequence Video = $i\n"; fi

	if [[ $AvecRepertoire==1 ]]
	then
		if [[ $Debug > 0 ]]; then printf "[Debug(1)] mkdir $RepDest/$i\n"; fi
		mkdir "$RepDest/$i"
		if [[ $Debug > 0 ]]; then printf "[Debug(1)] mkdir $RepDest/$i/Saison 1\n"; fi
		mkdir "$RepDest/$i/Saison 1"
	fi

	AfficheTravail

	k=""
	numscene=1

	for j in $(ls "$RepVideo/$i")
	do
		TestBadRep=0

		for t in $BadRep
		do
			if [[ $j == $t ]]
			then
				TestBadRep=1
			fi
		done

		if [[ $TestBadRep == 0 ]]
		then
			if [[ $k != "" ]]
			then
				ls "$RepVideo/$i/$k $j" > /dev/null 2>&1
				if [[ $? == 0 ]]
				then
					TestTaille "$RepVideo/$i/$k $j"
					if [[ $? == 0 ]]
					then
						if [[ $Debug > 1 ]]; then printf "[Debug(2)] Titre Scene Video numero $numscene (k) = $k $j\n"; fi

						fich_ext=$( echo "$j" | cut -d "." -f 2)

						if [[ $AvecRepertoire==1 ]]
						then
							nom_cible=$( printf "S01E%2d.$fich_ext" $numscene | tr " " "0")
							if [[ $Debug > 0 ]]; then printf "[Debug(1)] ln -s $RepVideo/$i/$k $j $RepDest/$i/Saison 1/$i - $nom_cible\n"; fi
							ln -s "$RepVideo/$i/$k $j" "$RepDest/$i/Saison 1/$i - $nom_cible"
						else
							if [[ $Debug > 0 ]]; then printf "[Debug(1)] ln -s $RepVideo/$i/$k $j $RepDest/$i-$numscene.$fich_ext\n"; fi
							ln -s "$RepVideo/$i/$k $j" "$RepDest/$i-$numscene.$fich_ext"
						fi

						numscene=$(($numscene+1))
					else
						if [[ $Debug > 0 ]]; then printf "[Debug(1)] $k $j trop petit\n"; fi
					fi
				else
					if [[ $Debug > 1 ]]; then printf "[Debug(2)] $RepVideo/$i/$k $j n'existe pas(k)\n"; fi
				fi

				k=""
			else
				ls "$RepVideo$i/$j" > /dev/null 2>&1
				if [[ $? == 0 ]]
				then
					TestTaille "$RepVideo/$i/$j"
					if [[ $? == 0 ]]
					then
						if [[ $Debug > 1 ]]; then printf "[Debug(2)] Titre Scene Video numero $numscene = $j\n"; fi

						fich_ext=$( echo "$j" | cut -d "." -f 2)

						if [[ $AvecRepertoire==1 ]]
						then
							nom_cible=$( printf "S01E%2d.$fich_ext" $numscene | tr " " "0")
							if [[ $Debug > 0 ]]; then printf "[Debug(1)] ln -s $RepVideo/$i/$j $RepDest/$i/Saison 1/$i - $nom_cible\n"; fi
							ln -s "$RepVideo/$i/$j" "$RepDest/$i/Saison 1/$i - $nom_cible"
						else
							if [[ $Debug > 0 ]]; then printf "[Debug(1)] ln -s $RepVideo/$i/$j $RepDest/$i-$numscene.$fich_ext\n"; fi
							ln -s "$RepVideo/$i/$j" "$RepDest/$i-$numscene.$fich_ext"
						fi

						numscene=$(($numscene+1))
					else
						if [[ $Debug > 0 ]]; then printf "[Debug(1)] $k trop petit\n"; fi
					fi
				else
					if [[ $Debug > 1 ]]; then printf "[Debug(2)] $RepVideo$i/$j n'existe pas k=$j\n"; fi
					k="$j"
				fi
			fi
		else
			if [[ $Debug > 1 ]]; then printf "[Debug(2)] $j est un mauvais nom\n"; fi
		fi
	done
done

if [[ $Debug > 1 ]]; then printf "[Debug(1)] Fin\n"; fi

printf "\r"
