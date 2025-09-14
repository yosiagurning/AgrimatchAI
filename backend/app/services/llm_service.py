from transformers import pipeline

class LLMService:
    def __init__(self):
        self.generator = pipeline("text-generation", model="gpt2")

    def chat(self, prompt: str, max_tokens: int = 128, temperature: float = 0.7):
        result = self.generator(
            prompt,
            max_new_tokens=max_tokens,
            temperature=temperature,
            num_return_sequences=1,
        )
        return result[0]["generated_text"]
