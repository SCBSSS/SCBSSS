from flask import Flask, request, jsonify
from openai import OpenAI
import os

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

app = Flask(__name__)

# assumes you set the OpenAI API key in an environment variable called OPENAI_API_KEY in the .zshrc file

@app.route('/summarize-entry', methods=['POST'])
def summarize_entry():
    data = request.json
    journal_entry = data.get('journal_entry')

    if not journal_entry:
        return jsonify({'error': 'No journal entry provided'}), 400

    try:
        # Adjusted to the new interface
        response = client.chat.completions.create(model="gpt-3.5-turbo",  # this can change, but let's keep it to this to start with
        messages=[{
            "role": "system",
            "content": "Summarize the following journal entry. Write the summary as if you're telling the person what they did or felt that day. Start by saying /'On this day/'." # the instruction given to the model
        }, {
            "role": "user",
            "content": journal_entry # the journal entry
        }])
        summary = response.choices[0].message.content # the summary of the journal entry

        return jsonify({'summary': summary})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)