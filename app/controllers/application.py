from bottle import template


class Application:

    def __init__(self):
        self.pages = {
            'index': self.index,
            'helper': self.helper,
        }

    def render(self, page):
        content = self.pages.get(page, self.index)
        return content()

    def index(self):
        return template('app/views/html/index')

    def helper(self):
        return template('app/views/html/helper')