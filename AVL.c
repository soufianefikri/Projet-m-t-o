

/*Écriture du script en shell:

Demander à l'utilisateur les données à analyser (précipitations, températures, humidité, vitesse et orientation des vents, etc.).
Demander à l'utilisateur le lieu et la période des données à analyser.
Lire les données de fichier et les filtrer en fonction des demandes de l'utilisateur.

CODE :

#!/bin/bash
Demander les données à analyser
echo "Quel type de données souhaitez-vous analyser ? (précipitations, températures, humidité, vitesse et orientation des vents, etc.)" read data_type
Demander le lieu et la période des données à analyser
echo "Quel est le lieu des données à analyser ?" read location echo "Quelle est la période des données à analyser (exemple: 2021-01-01 2021-01-31)?" read date_range
Lire les données du fichier et les filtrer
data_file="data_$location.txt" filtered_data_file="filtered_data_$location.txt" grep "$data_type" "$data_file" | awk -v d1="$date_range" '$1 >= d1 {print $0}' > "$filtered_data_file"
Appeler le programme C pour trier les données
sorted_data_file="sorted_data_$location.txt" ./tri_avl "$filtered_data_file" "$sorted_data_file"


Écriture du programme en C:

Écrire une fonction pour construire un AVL avec les données filtrées.
Écrire une fonction pour trier les données en utilisant l'AVL.
Écrire une fonction pour écrire les données triées dans un fichier de sortie.

CODE :*/

#include <stdio.h>
#include <stdlib.h>
struct Node {
int data;
int height;
struct Node *left;
struct Node *right;
};
int max(int a, int b) {
return (a &gt; b) ? a : b;

}
int height(struct Node *N) {
if (N == NULL)
return 0;
return N-&gt;height;
}
struct Node* newNode(int data) {
struct Node* node = (struct Node*) malloc(sizeof(struct Node));
node-&gt;data = data;
node-&gt;height = 1;
node-&gt;left = NULL;
node-&gt;right = NULL;
return(node);
}
struct Node *rightRotate(struct Node *y) {
struct Node *x = y-&gt;left;
struct Node *T2 = x-&gt;right;
x-&gt;right = y;
y-&gt;left = T2;
y-&gt;height = max(height(y-&gt;left), height(y-&gt;right)) + 1;
x-&gt;height = max(height(x-&gt;left), height(x-&gt;right)) + 1;
return x;
}
struct Node *leftRotate(struct Node *x) {
struct Node *y = x-&gt;right;
struct Node *T2 = y-&gt;left;
y-&gt;left = x;
x-&gt;right = T2;
x-&gt;height = max(height(x-&gt;left), height(x-&gt;right)) + 1;
y-&gt;height = max(height(y-&gt;left), height(y-&gt;right)) + 1;
return y;
}
int getBalance(struct Node *N) {
if (N == NULL)
return 0;
return height(N-&gt;left) - height(N-&gt;right);

}
struct Node* insert(struct Node* node, int data) {
if (node == NULL)
return(newNode(data));
if (data &lt; node-&gt;data)
node-&gt;left = insert(node-&gt;left, data);
else if (data &gt; node-&gt;data)
node-&gt;right = insert(node-&gt;right, data);
else
return node;
node-&gt;height = 1 + max(height(node-&gt;left), height(node-&gt;right));
int balance = getBalance(node);
if (balance &gt; 1 &amp;&amp; data &lt; node-&gt;left-&gt;data)
return rightRotate(node);
if (balance &lt; -1 &amp;&amp; data &gt; node-&gt;right-&gt;data)
return leftRotate(node);
if (balance &gt; 1 &amp;&amp; data &gt; node-&gt;left-&gt;data) {
node-&gt;left = leftRotate(node-&gt;left);
return rightRotate(node);
}
if (balance &lt; -1 &amp;&amp; data &lt; node-&gt;right-&gt;data) {
node-&gt;right = rightRotate(node-&gt;right);
return leftRotate(node);
}
return node;
}
void inOrder(struct Node *root) {
if (root != NULL) {
inOrder(root-&gt;left);
