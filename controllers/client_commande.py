#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


@client_commande.route('/client/commande/valide', methods=['POST'])
def client_commande_valide():
    mycursor = get_db().cursor()
    id_client = session['id_user']

    #selection des articles d'un panier
    sql = ''' 
    SELECT  nom_chaussure as nom, quantite, prix_chaussure as prix, j.stock_chaussure AS stock, ligne_panier.numchaussure AS id_article
    FROM ligne_panier
    JOIN chaussure j on j.num_chaussure = ligne_panier.numchaussure
    WHERE idutilisateur = %s;
    '''
    #articles_panier = []
    mycursor.execute(sql, id_client)
    articles_panier = mycursor.fetchall()

    #selection du prix total du panier
    if len(articles_panier) >= 1:
        sql = '''
        SELECT SUM(prix_chaussure*quantite) as prix_total
        FROM ligne_panier
        JOIN chaussure j on j.num_chaussure = ligne_panier.numchaussure
        WHERE idutilisateur = %s;
        '''
        mycursor.execute(sql, id_client)
        prix_total = mycursor.fetchone()
    else:
        prix_total = None
    # etape 2 : selection des adresses
    sql = '''SELECT id_adresse, nom, rue, code_postal, ville FROM adresse WHERE utilisateur_id = %s AND valide = 1 ORDER BY date_utilisation DESC;'''
    mycursor.execute(sql, id_client)
    adresses = mycursor.fetchall()
    return render_template('client/boutique/panier_validation_adresses.html'
                           , adresses=adresses
                           , articles_panier=articles_panier
                           , prix_total=prix_total
                           , validation=1
                           )

@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()

    date = datetime.now().strftime('%Y-%m-%d')
    id_user = session['id_user']
    id_adresse_livraison = request.form.get('id_adresse_livraison')
    id_adresse_facturation = request.form.get('id_adresse_facturation')
    tuple = (date, id_user, id_adresse_facturation, id_adresse_livraison)
    id_adresse_livraison = request.form.get('id_adresse_livraison')

    if request.form.get('adresse_identique'):
        id_adresse_facturation = id_adresse_livraison
    else:
        id_adresse_facturation = request.form.get('id_adresse_facturation')

    tuple = (date, id_user, id_adresse_facturation, id_adresse_livraison)
    sql = "insert into commande(date_achat, idetat, idutilisateur, id_adresse_fact, id_adresse_livr) values(%s,1,%s, %s, %s);"
    mycursor.execute(sql, tuple)

    #mettre à jour la date des adresses

    sql = '''UPDATE adresse SET date_utilisation = %s WHERE id_adresse IN (%s, %s)'''
    tuple_update = (date, id_adresse_facturation, id_adresse_livraison)
    mycursor.execute(sql, tuple_update)

    sql = "select last_insert_id() as last_insert_id from commande where idutilisateur = %s;"
    mycursor.execute(sql, id_user)
    commande_last_id = mycursor.fetchone()

    sql = "select * from ligne_panier where idutilisateur = %s;"
    mycursor.execute(sql, id_user)
    panier = mycursor.fetchall()

    for item in panier:
        sql = "select prix_chaussure from chaussure where num_chaussure = %s;"
        mycursor.execute(sql, item['numchaussure'])
        prix = mycursor.fetchone()
        sql = '''insert into ligne_commande(numchaussure, idcommande, prix, quantite) values (%s,%s,%s,%s);'''
        mycursor.execute(sql, (item['numchaussure'], commande_last_id['last_insert_id'], prix['prix_chaussure'], item['quantite']))

    sql = '''select * from ligne_commande;'''
    mycursor.execute(sql)
    resultat = mycursor.fetchall()
    print(resultat)

    sql = "delete from ligne_panier where idutilisateur = %s;"
    mycursor.execute(sql, id_user)
    get_db().commit()
    flash(u'Commande ajoutée')
    return redirect('/client/article/show')




@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']



    sql = '''  SELECT date_achat AS date_achat, SUM(lc.quantite) AS nbr_articles, SUM(lc.prix*lc.quantite) AS prix_total, e.libelle_etat AS libelle, commande.idetat AS etat_id, lc.idcommande AS id_commande
               FROM commande
               JOIN ligne_commande lc on commande.id_commande = lc.idcommande
               JOIN etat e on commande.idetat = e.id_etat
               WHERE idutilisateur = %s
               GROUP BY id_commande
               ORDER BY commande.idetat, commande.date_achat; '''


    mycursor.execute(sql, id_client)
    commandes = mycursor.fetchall()


    articles_commande = None
    commande_adresses = None
    id_commande = request.args.get('id_commande', None)
    if id_commande != None:
        print(id_commande)
        sql = ''' SELECT nom_chaussure AS nom, prix, quantite, prix*quantite AS prix_ligne
                  FROM commande
                  JOIN ligne_commande lc on commande.id_commande = lc.idcommande
                  JOIN chaussure on lc.numchaussure = chaussure.num_chaussure
                  WHERE commande.id_commande=%s; '''
        mycursor.execute(sql, (id_commande))
        articles_commande = mycursor.fetchall()


        # partie 2 : selection de l'adresse de livraison et de facturation de la commande selectionnée
        sql = ''' SELECT af.nom AS nom_facturation, af.rue AS rue_facturation, af.code_postal AS code_postal_facturation, af.ville AS ville_facturation,
                    al.nom AS nom_livraison, al.rue AS rue_livraison, al.code_postal AS code_postal_livraison, al.ville AS ville_livraison
                    FROM adresse AS af
                    JOIN commande ON af.id_adresse = id_adresse_fact
                    JOIN adresse AS al ON id_adresse_livr = al.id_adresse
                    WHERE id_commande = %s; '''
        mycursor.execute(sql, (id_commande))
        commande_adresses = mycursor.fetchone()

    return render_template('client/commandes/show.html'
                           , commandes=commandes
                           , articles_commande=articles_commande
                           , commande_adresses=commande_adresses
                           )

