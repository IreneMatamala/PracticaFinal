from flask import Flask, jsonify, request
import logging
import os
import time
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter

app = Flask(__name__)

trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

otlp_exporter = OTLPSpanExporter(endpoint="http://otel-collector.monitoring:4318")
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/')
def home():
    with tracer.start_as_current_span("home_endpoint"):
        logger.info("Home endpoint accessed")
        return jsonify({"message": "Welcome to TechWave Solutions API", "status": "healthy"})

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "timestamp": time.time()})

@app.route('/ready')
def ready():
    return jsonify({"status": "ready", "timestamp": time.time()})

@app.route('/api/data')
def get_data():
    with tracer.start_as_current_span("get_data_endpoint"):
        logger.info("Data endpoint accessed")
        time.sleep(0.1)
        return jsonify({
            "data": [
                {"id": 1, "name": "Item 1", "value": 100},
                {"id": 2, "name": "Item 2", "value": 200},
                {"id": 3, "name": "Item 3", "value": 300}
            ],
            "count": 3
        })

@app.route('/api/users', methods=['POST'])
def create_user():
    with tracer.start_as_current_span("create_user_endpoint"):
        user_data = request.get_json()
        logger.info(f"Creating user: {user_data}")
        return jsonify({"id": 123, "status": "created", **user_data}), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)