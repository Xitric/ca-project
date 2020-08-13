from flask_wtf import Form
from wtforms import StringField

class PostForm(Form):
    title = StringField('Title')
    user_name = StringField('user_name')
    body  = StringField('Body')

