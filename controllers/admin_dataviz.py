#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

admin_dataviz = Blueprint('admin_dataviz', __name__,
                        template_folder='templates')

@admin_dataviz.route('/admin/dataviz/etat1')
def show_type_article_stock():
    mycursor = get_db().cursor()
    sql = '''SELECT LEFT(code_postal, 2) AS code, COUNT(DISTINCT utilisateur.id_utilisateur) AS nombre_utilisateurs, COUNT(DISTINCT commande.id_commande) AS nombre_commandes
            FROM adresse
            LEFT JOIN utilisateur ON adresse.utilisateur_id = utilisateur.id_utilisateur
            LEFT JOIN commande ON adresse.id_adresse = commande.id_adresse_livr
            GROUP BY LEFT(code_postal, 2)
            ORDER BY code ASC;
           '''
    mycursor.execute(sql)
    datas_show = mycursor.fetchall()
    labels = [str(row['code']) for row in datas_show]
    values = [int(row['nombre_utilisateurs']) for row in datas_show]

    # sql = '''
    #         
    #        '''
    return render_template('admin/dataviz/dataviz_etat_1.html'
                           , datas_show=datas_show
                           , labels=labels
                           , values=values)

