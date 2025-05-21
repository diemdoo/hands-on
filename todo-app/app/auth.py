# app/auth.py
from flask import render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required, current_user
from . import db
from .models import User
from werkzeug.security import generate_password_hash, check_password_hash

def init_auth_routes(app):
    @app.route('/register', methods=['GET', 'POST'])
    def register():
        if current_user.is_authenticated:
            return redirect(url_for('index'))
        if request.method == 'POST':
            username = request.form.get('username')
            password = request.form.get('password')
            if User.query.filter_by(username=username).first():
                flash('Username already exists!', 'danger')
                return redirect(url_for('register'))
            new_user = User(username=username, password=generate_password_hash(password))
            db.session.add(new_user)
            db.session.commit()
            flash('Registration successful! Please log in.', 'success')
            return redirect(url_for('login'))
        return render_template('register.html')

    @app.route('/login', methods=['GET', 'POST'])
    def login():
        if current_user.is_authenticated:
            return redirect(url_for('index'))
        if request.method == 'POST':
            username = request.form.get('username')
            password = request.form.get('password')
            user = User.query.filter_by(username=username).first()
            if user and check_password_hash(user.password, password):
                login_user(user)
                flash('Logged in successfully!', 'success')
                return redirect(url_for('index'))
            flash('Invalid username or password!', 'danger')
            return redirect(url_for('login'))
        return render_template('login.html')

    @app.route('/logout')
    @login_required
    def logout():
        logout_user()
        flash('Logged out successfully!', 'success')
        return redirect(url_for('login'))