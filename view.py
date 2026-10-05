import sys
from PySide6.QtWidgets import QApplication, QWidget, QVBoxLayout, QTextBrowser
from pathlib import Path

class Window(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("PDF/JPG Info")
        self.resize(700, 400)

        browser = QTextBrowser()
        
        

        html_file = Path("test.html")
        
        styled_html = f"""
        <html>
        <head>
        <style>
        body {{
            font-family: Arial;
            line-height: 1.3;
            padding: 12px;
            font-size: small;
        }}
        img {{
            max-width: 100%;
            height: auto;
            display: block;
            margin: 5px auto;
            cursor: zoom-in;
        }}
        h1 {{ 
            color: #1a73e8; 
            font-size: xx-large;
        }}
        h2 {{
            font-size: x-large;
        }}
        h3 {{
            font-size: large;
        }}
        h4 {{
            font-size: medium;
        }}
        th, td {{
            padding: 2px 2px;
            text-align: left;
        }}

        th {{
            font-weight: bold;
        }}

        p {{
            margin-top: 1px;
            margin-bottom: 1px;
        }}
        
        ul, ol {{
            margin-top: 4px;
            margin-bottom: 4px;
            padding-left: 24px;
        }}

        li p {{
            margin: 0;
        }}
        </style>
        </head>
        <body>
        {html_file.read_text(encoding="utf-8")}
        </body>
        </html>
        """

        browser.setHtml(styled_html)

        layout = QVBoxLayout(self)
        layout.addWidget(browser)


app = QApplication(sys.argv)
window = Window()
window.show()
sys.exit(app.exec())

