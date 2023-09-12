:: Script to run test version of the documentation on http://localhost:8000/

python -m venv .venv --upgrade-deps
call .venv/Scripts/activate
pip install mkdocs-material --upgrade
mkdocs serve