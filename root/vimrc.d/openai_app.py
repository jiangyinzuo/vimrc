#!/bin/python3

import os
import openai


class OpenAIApp:
    """
    https://stackoverflow.com/questions/74711107/openai-api-continuing-conversation
    """
    
    def __init__(self):
        # Setting the API key to use the OpenAI API
        # openai.api_key = os.getenv("OPENAI_API_KEY")
        with open(f'{os.getenv("HOME")}/openai_token.txt') as f:
            openai.api_key = f.readline().strip()
        self.messages = []

    def chat(self, message):
        self.messages.append({"role": "user", "content": message})
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=self.messages
        )
        self.messages.append({"role": "assistant", "content": response["choices"][0]["message"].content})
        return response["choices"][0]["message"].content
    

if __name__ == '__main__':
    import sys
    if len(sys.argv) == 0:
        print('openai.py <command>')
        exit(-1)

    app = OpenAIApp()
    match sys.argv[1]:
        case 'chat':
            print('开始聊天')
            while True:
                try:
                    message = input('> ')
                    match message:
                        case 'clear':
                            app.messages.clear()
                            os.system('clear')
                            print('已清空')
                        case _:
                            print(app.chat(message))
                except openai.error.APIError as e:
                    print(e)
                except KeyboardInterrupt:
                    print('再见')
                    exit(0)
