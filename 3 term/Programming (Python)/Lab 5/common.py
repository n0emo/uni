from functools import reduce

def compose2(f, g): return lambda *a, **kw : f(g(*a, **kw))

def compose(*fs): return reduce(compose2, fs)
