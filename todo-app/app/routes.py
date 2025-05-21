# app/routes.py
from flask import render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from . import db
from .models import Task

def init_routes(app):
    @app.route('/', methods=['GET', 'POST'])
    @login_required
    def index():
        if request.method == 'POST':
            task_desc = request.form.get('task')
            task_details = request.form.get('details') or None  # Chuyển thành None nếu rỗng
            # Kiểm tra độ dài của details
            if task_details and len(task_details) > 100:
                flash('Details cannot exceed 100 characters!', 'danger')
                return redirect(url_for('index'))
            if task_desc:
                new_task = Task(description=task_desc, details=task_details, user_id=current_user.id)
                db.session.add(new_task)
                db.session.commit()
            return redirect(url_for('index'))
        
        page = request.args.get('page', 1, type=int)
        tasks = Task.query.filter_by(user_id=current_user.id).paginate(page=page, per_page=5, error_out=False)
        return render_template('index.html', tasks=tasks)

    @app.route('/delete/<int:task_id>')
    @login_required
    def delete(task_id):
        task = Task.query.get_or_404(task_id)
        if task.user_id != current_user.id:
            flash('You can only delete your own tasks!', 'danger')
            return redirect(url_for('index'))
        db.session.delete(task)
        db.session.commit()
        return redirect(url_for('index'))
    
    @app.route('/toggle/<int:task_id>')
    @login_required
    def toggle(task_id):
        task = Task.query.get_or_404(task_id)
        if task.user_id != current_user.id:
            flash('You can only toggle your own tasks!', 'danger')
            return redirect(url_for('index'))
        task.completed = not task.completed
        db.session.commit()
        return redirect(url_for('index'))
    
    @app.route('/clear')
    @login_required
    def clear():
        Task.query.filter_by(user_id=current_user.id).delete()
        db.session.commit()
        return redirect(url_for('index'))

    @app.route('/edit/<int:task_id>', methods=['GET', 'POST'])
    @login_required
    def edit(task_id):
        task = Task.query.get_or_404(task_id)
        if task.user_id != current_user.id:
            flash('You can only edit your own tasks!', 'danger')
            return redirect(url_for('index'))
        if request.method == 'POST':
            task.description = request.form.get('task')
            task.details = request.form.get('details') or None
            # Kiểm tra độ dài của details
            if task.details and len(task.details) > 100:
                flash('Details cannot exceed 100 characters!', 'danger')
                return redirect(url_for('edit', task_id=task.id))
            if not task.description:
                flash('Task description cannot be empty!', 'danger')
                return redirect(url_for('edit', task_id=task.id))
            db.session.commit()
            flash('Task updated successfully!', 'success')
            return redirect(url_for('index'))
        return render_template('edit.html', task=task)