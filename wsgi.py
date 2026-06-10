# Конфигурация WSGI для PythonAnywhere
# Замените 'romanenko' на ваше имя пользователя PythonAnywhere

import sys
import os

# Путь к проекту (поменяйте romanenko на ваш username)
project_home = '/home/romanenko/ecp_registry'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Переходим в директорию проекта (важно для init_db.py путей)
os.chdir(project_home)

from app import app as application
