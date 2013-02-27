#!/usr/bin/python2.7
import re
#-----generator
def match_sxz(noun):
    return re.search('[sxz]$', noun)
def apply_sxz(noun):
    return re.sub('$', 'es', noun)
def match_y(noun):                             
    return re.search('[^aeiou]y$', noun)
def apply_y(noun):                            
    return re.sub('y$', 'ies', noun)
def match_default(noun):
    return True
def apply_default(noun):
    return noun + 's'

rules = ((match_sxz, apply_sxz), (match_y, apply_y), (match_default, apply_default))
def plural1(noun):          
    for matches_rule, apply_rule in rules:      
        if matches_rule(noun):
            return apply_rule(noun)
#----------- itrator 
class LazyRules:
    rules_filename = 'replace_rule.txt'
    def __init__(self):
        self.pattern_file = open(self.rules_filename)
        self.cache = []
    def __iter__(self):
        self.cache_index = 0
        return self
    def __next__(self):
        self.cache_index += 1
        if len(self.cache) >= self.cache_index:
            return self.cache[self.cache_index - 1]
        if self.pattern_file.closed:
            raise StopIteration
        line = self.pattern_file.readline()
        if not line:
            self.pattern_file.close()
            raise StopIteration
        pattern, search, replace = line.split(None,3)
        funcs = build_match_and_apply_functions(
            pattern, search, replace)
        self.cache.append(funcs) #复数规则从文件中读取，存入LazyRules.cache[]中
        return funcs # 返回值总是一对函数
rules = LazyRules()
