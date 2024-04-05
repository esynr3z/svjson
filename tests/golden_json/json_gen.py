import json

with open("pizza.json", "r", encoding="utf-8") as file:
    data = json.load(file)
    with open("pizza_indent0.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=None, separators=(",", ":"), sort_keys=True)
    with open("pizza_indent2.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, sort_keys=True)
    with open("pizza_indent4.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4, sort_keys=True)

with open("recipes.json", "r", encoding="utf-8") as file:
    data = json.load(file)
    with open("recipes_indent0.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=None, separators=(",", ":"), sort_keys=True)
    with open("recipes_indent2.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, sort_keys=True)
    with open("recipes_indent4.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4, sort_keys=True)

with open("video.json", "r", encoding="utf-8") as file:
    data = json.load(file)
    with open("video_indent0.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=None, separators=(",", ":"), sort_keys=True)
    with open("video_indent2.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, sort_keys=True)
    with open("video_indent4.json", "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4, sort_keys=True)
