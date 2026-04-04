import numpy as np
import tflite_runtime.interpreter as tflite
from flask import Flask, request, jsonify

app = Flask(__name__)

# Cargar el modelo YAMNet
interpreter = tflite.Interpreter(model_path="assets/models/yamnet.tflite")
interpreter.allocate_tensors()

CLAP_CLASSES = [58, 62] # Clapping, Applause

@app.route('/classify', methods=['POST'])
def classify():
    try:
        data = request.get_json()
        samples = np.array(data['samples'], dtype=np.float32)
        
        print(f"📊 Recibidas {len(samples)} muestras")

        # Preparar entrada para el modelo
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()
        
        print(f"🔍 Input shape esperado: {input_details[0]['shape']}")
        print(f"🔍 Samples shape: {samples.shape}")
        
        # Reshape si es necesario
        input_shape = input_details[0]['shape']
        if len(input_shape) > 1:
            samples = samples.reshape(input_shape)
        
        interpreter.set_tensor(input_details[0]['index'], samples)
        interpreter.invoke()
        
        # Obtener scores
        scores = interpreter.get_tensor(output_details[0]['index'])[0]
        
        clap_scores = [scores[i] for i in CLAP_CLASSES]
        max_clap_score = max(clap_scores)
        
        is_clap = max_clap_score > 0.300
        
        print(f"✅ Clasificación: {'APLAUSO' if is_clap else 'no aplauso'} (confianza: {max_clap_score:.3f})")
        
        return jsonify({
            'clap': bool(is_clap),
            'confidence': float(max_clap_score)
        })
    
    except Exception as e:
        print(f"❌ Error en classify: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

if __name__ == '__main__':
    print("🎯 Servidor YAMNet iniciado en http://localhost:5000")
    print("📊 Modelo cargado y listo para clasificar aplausos")
    app.run(host='0.0.0.0', port=5000, debug=False)
