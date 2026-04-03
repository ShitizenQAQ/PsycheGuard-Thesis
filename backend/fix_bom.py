
import os

def strip_bom(path):
    with open(path, 'rb') as f:
        content = f.read()
    if content.startswith(b'\xef\xbb\xbf'):
        print(f"Removing BOM from {path}")
        with open(path, 'wb') as f:
            f.write(content[3:])
    else:
        print(f"No BOM found in {path}")

strip_bom('d:/projectg/psycheguard/PsycheGuard/backend/src/main/resources/data.sql')
strip_bom('d:/projectg/psycheguard/PsycheGuard/backend/src/main/resources/init.sql')
