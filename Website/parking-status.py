from flask import Flask, render_template, jsonify
from parking_db import get_parking_status, get_recent_events

app = Flask(__name__)


@app.route('/')
def home():
    return render_template('home.html')


@app.route('/api/get_parking_status')
def parking_status():
    status = get_parking_status()
    return jsonify(status)


@app.route('/api/recent_events')
def recent_events():
    events = get_recent_events()
    return jsonify(events)


if __name__ == '__main__':
    app.run(debug=True)
