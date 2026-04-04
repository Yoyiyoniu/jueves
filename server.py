import numpy as np
import tflite_runtime.interpreter as tflite
from flask import Flask, request, jsonify

app = Flask(__name__)

interpreter = tflite.Interpreter(model_path="assets/models/yamnet.tflite")
interpreter.allocate_tensors()

CLAP_CLASSES = [58, 62]
THRESHOLD = 0.300

@app.route('/classify', methods=['POST'])
def classify():
    try:
        samples = np.array(request.get_json()['samples'], dtype=np.float32)
        
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()
        
        if len(input_details[0]['shape']) > 1:
            samples = samples.reshape(input_details[0]['shape'])
        
        interpreter.set_tensor(input_details[0]['index'], samples)
        interpreter.invoke()
        
        scores = interpreter.get_tensor(output_details[0]['index'])[0]
        max_clap_score = max(scores[i] for i in CLAP_CLASSES)
        
        return jsonify({
            'clap': bool(max_clap_score > THRESHOLD),
            'confidence': float(max_clap_score)
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
