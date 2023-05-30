#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_coordonnee = Blueprint('client_coordonnee', __name__,
                        template_folder='templates')

@client_coordonnee.route('/client/coordonnee/show')
def client_coordonnee_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''SELECT nom,login,email FROM utilisateur WHERE id_utilisateur = %s'''
    mycursor.execute(sql, id_client)
    utilisateur = mycursor.fetchone()
    sql = '''SELECT id_adresse, nom, rue, code_postal, ville FROM adresse WHERE utilisateur_id = %s AND valide = 1;'''
    mycursor.execute(sql, id_client)
    adresses = mycursor.fetchall()
    nb_adresses = 4
    sql = '''SELECT COUNT(id_adresse) AS nb_adresses FROM adresse WHERE utilisateur_id = %s AND valide = 1;'''
    mycursor.execute(sql, id_client)
    temp_nb_adr = mycursor.fetchone()
    if 'nb_adresses' in temp_nb_adr.keys():
        nb_adresses = temp_nb_adr['nb_adresses']
    return render_template('client/coordonnee/show_coordonnee.html'
                           , utilisateur=utilisateur
                           , adresses=adresses
                           , nb_adresses=nb_adresses
                           )

@client_coordonnee.route('/client/coordonnee/edit', methods=['GET'])
def client_coordonnee_edit():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''SELECT nom,login,email FROM utilisateur WHERE id_utilisateur = %s'''
    mycursor.execute(sql, id_client)
    utilisateur = mycursor.fetchone()

    return render_template('client/coordonnee/edit_coordonnee.html'
                           ,user=utilisateur
                           )

@client_coordonnee.route('/client/coordonnee/edit', methods=['POST'])
def client_coordonnee_edit_valide():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    nom=request.form.get('nom')
    login = request.form.get('login')
    email = request.form.get('email')
    sql='''SELECT login, email FROM utilisateur WHERE (login = %s or email = %s) AND id_utilisateur != %s'''
    mycursor.execute(sql, (login, email, id_client))
    user = mycursor.fetchall()
    if len(user) != 0:
        sql = '''SELECT nom,login,email FROM utilisateur WHERE id_utilisateur = %s'''
        mycursor.execute(sql, id_client)
        user = mycursor.fetchone()
        flash(u'votre cet Email ou ce Login existe déjà pour un autre utilisateur', 'alert-warning')
        return render_template('client/coordonnee/edit_coordonnee.html'
                               , user=user
                               )
    sql='''UPDATE utilisateur SET nom=%s, login=%s, email=%s WHERE id_utilisateur = %s'''
    tuple_update = (nom,login,email,id_client)
    mycursor.execute(sql, tuple_update)
    get_db().commit()
    return redirect('/client/coordonnee/show')


@client_coordonnee.route('/client/coordonnee/delete_adresse',methods=['POST'])
def client_coordonnee_delete_adresse():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_adresse= request.form.get('id_adresse')
    sql='''UPDATE adresse SET valide = 2 WHERE id_adresse = %s AND utilisateur_id = %s'''
    mycursor.execute(sql,(id_adresse, id_client))
    get_db().commit()
    return redirect('/client/coordonnee/show')

@client_coordonnee.route('/client/coordonnee/add_adresse')
def client_coordonnee_add_adresse():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''SELECT nom,login FROM utilisateur WHERE id_utilisateur = %s'''
    mycursor.execute(sql, id_client)
    utilisateur = mycursor.fetchone()
    return render_template('client/coordonnee/add_adresse.html'
                           ,utilisateur=utilisateur
                           )

@client_coordonnee.route('/client/coordonnee/add_adresse',methods=['POST'])
def client_coordonnee_add_adresse_valide():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    nom= request.form.get('nom')
    rue = request.form.get('rue')
    code_postal = request.form.get('code_postal')
    ville = request.form.get('ville')
    sql='''INSERT INTO adresse(nom, rue, code_postal, ville, valide, utilisateur_id) VALUES (%s,%s,%s,%s,1,%s);'''
    tuple_update = (nom, rue, code_postal, ville, id_client)
    mycursor.execute(sql, tuple_update)
    get_db().commit()
    return redirect('/client/coordonnee/show')

@client_coordonnee.route('/client/coordonnee/edit_adresse')
def client_coordonnee_edit_adresse():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_adresse = request.args.get('id_adresse')
    sql='''SELECT login, nom FROM utilisateur WHERE id_utilisateur = %s'''
    mycursor.execute(sql, id_client)
    utilisateur = mycursor.fetchone()
    sql = '''SELECT id_adresse, nom, rue, code_postal, ville FROM adresse WHERE id_adresse = %s AND utilisateur_id = %s'''
    mycursor.execute(sql, (id_adresse, id_client))
    adresse = mycursor.fetchone()
    return render_template('/client/coordonnee/edit_adresse.html'
                            ,utilisateur=utilisateur
                            ,adresse=adresse
                           )

@client_coordonnee.route('/client/coordonnee/edit_adresse',methods=['POST'])
def client_coordonnee_edit_adresse_recoit():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    nom= request.form.get('nom')
    rue = request.form.get('rue')
    code_postal = request.form.get('code_postal')
    ville = request.form.get('ville')
    id_adresse = request.form.get('id_adresse')
    sql='''UPDATE adresse SET nom = %s, rue = %s, code_postal = %s, ville = %s WHERE id_adresse =%s AND utilisateur_id = %s'''
    tuple_update = (nom, rue, code_postal, ville, id_adresse, id_client)
    mycursor.execute(sql, tuple_update)
    get_db().commit()
    return redirect('/client/coordonnee/show')