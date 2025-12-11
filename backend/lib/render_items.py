import json, sys, markdown, re, yaml
from pathlib import Path

def render_items(folder): 
  base = Path(__file__).resolve().parent.parent.parent
  input_dir = base / 'backend' / 'data' / folder 
  output_path = base / 'frontend' / 'src' / 'data' / f"{folder}Data.json"

  # Changes: Instead of importing a json file, 
  # we should be collecting all the markdown files in a dirctory called data/projects and the front matter will create the dictiionary structure.

  markdown_files = list(input_dir.glob("*.md"))

  items = []
  for md_file in markdown_files:
    content = md_file.read_text(encoding='utf-8')

    # Extract from matter (between --- ---)
    match = re.match(r"---\s*\n(.*?)\n---\s*\n(.*)", content, re.DOTALL)
    if not match:
      print(f"⚠️  No front matter found in {md_file.name}, skipping.")
      continue

    front_matter, body = match.groups()
    metadata = yaml.safe_load(front_matter)
    metadata["body_html"] = markdown.markdown(body, extensions=["fenced_code", "codehilite"])
    items.append(metadata)

  with open(output_path, 'w', encoding='utf-8') as f:
    json.dump(items, f, ensure_ascii=False, indent=2)
