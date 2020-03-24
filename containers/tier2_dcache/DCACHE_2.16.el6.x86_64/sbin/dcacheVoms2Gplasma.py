#!/usr/bin/python
from __future__ import generators
import sys
from xml.dom import minidom
from xml.dom import Node
import urllib
import getopt
import os
import commands


def usage():
    print 'dcacheVoms2Gplasma.py'
    print
    print ' -h, --help                  Display help information'
    print ' -v, --version               Version'
    print ' -c, --config                Set config file'
    print ' -a, --authzdb               Gernerate authzdb'
    print ' -r, --vorolemap             Gernerate vorolemap'
    print ' -q, --query                 Query voms server'


def doc_order_iter_filter(node, filter_func):
    """
    Iterates over each node in document order,
    applying the filter function to each in turn,
    starting with the given node, and yielding each node in
    cases where the filter function computes true
    node - the starting point
           (subtree rooted at node will be iterated over document order)
    filter_func - a callable object taking a node and returning
                  true or false
    """
    if filter_func(node):
        yield node
    for child in node.childNodes:
        for cn in doc_order_iter_filter(child, filter_func):
            yield cn
    return


def get_all_elements(node):
    """
    Returns an iterator (using document order) over all element nodes
    that are descendants of the given one
    """
    return doc_order_iter_filter(
        node, lambda n: n.nodeType == Node.ELEMENT_NODE
        )


def readVomsServer(url,key_file='/etc/grid-security/hostkey.pem',cert_file='/etc/grid-security/hostcert.pem'):
    opener =urllib.URLopener(key_file='/etc/grid-security/hostkey.pem',cert_file='/etc/grid-security/hostcert.pem') ;
    xml = opener.open(url)
    doc = minidom.parseString(xml.read())
    for elem in get_all_elements(doc):

        if (("item" == elem.localName) or ("getGridmapUsersReturn" == elem.localName ) and not elem.attributes.has_key("soapenc:arrayType")):
               # Then we 
            for node in elem.childNodes:
                   if node.nodeType == node.TEXT_NODE:
                      yield '"' + node.data + '"'
    return


class configfile:
    def __init__(self):
        self.filename = ""
        self.vorolemap = "/etc/grid-security/grid-vorolemap"
        self.authzdb = "/etc/grid-security/storage-authzdb"
    def propFileNameSet(self,configFileName):
        self.Content = []
        self.Groups = []
        parsedLines = []
        self.filename = configFileName
        for lineUnProcessed in open(self.filename):
            lineStriped = lineUnProcessed.strip()
            if len(lineStriped) > 0 :
                if lineStriped[0] != "#":
                    lineSplit = []
                    splitInfo = ""
                    for character in lineStriped:
                        if not character in [' ', '\t', '\r']:
                            splitInfo += character
                        else:
                            if len(splitInfo) > 0:
                                lineSplit.append(splitInfo)
                            splitInfo = ""
                    if len(splitInfo) > 0:
                        lineSplit.append(splitInfo)
                    parsedLines.append(lineSplit)
        for parsedLine in parsedLines:
            if len(parsedLine) == 2:
                if parsedLine[0] == 'authzdb':
                    self.authzdb = parsedLine[1]
                if parsedLine[0] == 'vorolemap':
                    self.vorolemap = parsedLine[1]
            if len(parsedLine) == 3:
                if parsedLine[0] == 'group':
                    url = parsedLine[1]
                    group = parsedLine[2]
                    acont = {'group':group,'url':url}
                    splitUrl = url.split('container=')
                    if len(splitUrl) > 1:
                        role = splitUrl[1]
                        acont['role'] = role
                    self.Content.append(acont)
                    found = False
                    for item in self.Groups:
                      if item['group'] == group:
                        found = True
                    if not found:
                        self.Groups.append(acont)
                if parsedLine[0] == 'gmf_local':
                    filename = parsedLine[1]
                    postfix = parsedLine[2]
                    for unparsedLine in open(filename):
                        splitLine = unparsedLine.split('.')
                        if 2 == len(splitLine):
                            dn = splitLine[0].strip()
                            prefix = splitLine[1].strip()
                            acont = {'group':group,'dn':dn,'gid':gid ,'uid' : uid}
                            
                            self.Content.append(acont)
                            found = False
                            for item in self.Groups:
                              if item['group'] == group:
                                found = True
                            if not found:
                                self.Groups.append(acont)
            if len(parsedLine) == 5:
                if parsedLine[0] == 'group':
                    url = parsedLine[1]
                    group = parsedLine[2]
                    uid = parsedLine[3]
                    gid =  parsedLine[4]
                    splitUrl = url.split('container=')
                    acont = {'group':group,'gid':gid ,'uid' : uid,'url' : url}
                    if len(splitUrl) > 1:
                        role = splitUrl[1]
                        acont['role'] = role
                    self.Content.append(acont)
                    found = False
                    for item in self.Groups:
                      if item['group'] == group:
                        found = True
                    if not found:
                      self.Groups.append(acont)
                    
        return
                    
    def propGroupsGet(self):
        return self.Groups
    def propContentGet(self):
        return self.Content
    def propFileNameAuthzDbGet(self):
        return self.authzdb
    def propFileNameVoRolemapGet(self):
        return self.vorolemap
      

class authzdb:
    def __init__(self):
        self.filename = ""
    def propCfgSet(self,cfg):
        self.cfg = cfg
    def propFileNameSet(self,FileName):
        self.FileName = FileName
    def generate(self):
        allgroups = self.cfg.propGroupsGet()
        foundGroups = []
        missingGroups = []
        if os.path.isfile(self.FileName):
            for unparsedLine in open(self.FileName):
                stripedUnunparsedLine = unparsedLine.strip()
                if len(stripedUnunparsedLine) > 0:
                    if stripedUnunparsedLine[0] != '#':
                        splitInfo = ""
                        lineSplit = []
                        for character in stripedUnunparsedLine:
                            if not character in [' ', '\t', '\r']:
                                splitInfo += character
                            else:
                                if len(splitInfo) > 0:
                                    lineSplit.append(splitInfo)
                                splitInfo = ""
                        if len(splitInfo) > 0:
                            lineSplit.append(splitInfo)
                        if len(lineSplit) > 1:
                            if lineSplit[0] == 'authorize':
                                if lineSplit[1] not in foundGroups:
                                    foundGroups.append(lineSplit[1])
        else:
            fp = open(self.FileName,'w')
            try:
                fp.write('# storage-authzdb created by dcacheVoms2Gplasma\n')
                fp.write('version 2.1\n\n')
            finally:
                fp.close()
        missingGroups = []
        for group in allgroups:
            if group["group"] not in foundGroups:
                missingGroups.append(group)
        if len(missingGroups) > 0:
            fp = open(self.FileName,'a')
            try:
                for group in missingGroups:
                    if not group.has_key('uid'):
                      cmd = "id -u %s" % (group['group'])
                      (rc,cmdoutput) = commands.getstatusoutput(cmd)
                      if rc != 0:
                        print 'ERROR: UID not found for "%s"' % (group['group'])
                        continue
                      group['uid'] = cmdoutput.strip()
                    if not group.has_key('gid'):
                      cmd = "id -g %s" % (group['group'])
                      (rc,cmdoutput) = commands.getstatusoutput(cmd)
                      if rc != 0:
                        print 'ERROR: GID not found for "%s"' % (group['group'])
                        continue
                      group['gid'] = cmdoutput.strip()
                    fp.write('\n# authzdb for %s added by dcacheVoms2Gplasma\n' % (group['group']))
                    fp.write('authorize %s read-write %s %s / / /\n' % (group['group'],group['uid'],group['gid']))
            finally:
                fp.close()
     
class vorolemap:
    def __init__(self):
        self.filename = ""
        self.queryVoms = False
    def propCfgSet(self,cfg):
        self.cfg = cfg
    def propFileNameSet(self,FileName):
        self.FileName = FileName 
    def propQueryVomsSet(self,Value):
        self.queryVoms = Value 
               
    def generate(self):
        fp = open(self.FileName,"w")
        try:
            fp.write("# grid-vorolemap file was generated by dcacheVoms2Gplasma.py\n\n")
            #fp.write("\n")
            for content in self.cfg.propContentGet():
                if content.has_key('role'):
                    fp.write('# Added role ' + content['role'] + '\n')
                    fp.write('"*" "' + content['role'] + '" ' + content['group'] + '\n\n')
            
            for content in self.cfg.propContentGet():
                if content.has_key('dn'):
                    fp.write(content['dn'] + ' ' + content['group'] + '\n')
                    
            if (self.queryVoms):
                fp.write('# Voms queried DNs\n\n')
                
                for content in self.cfg.propContentGet():
                    if content.has_key('url'):
                        
                        try:
                            for dn in readVomsServer(content['url']):
                                try:
                                    fp.write(dn + ' ' + content['group'] + '\n')
                                except:
                                    print 'ERROR: Error adding dn %s for %s to grid-vorolemap' % (dn,content['group'])
                        except :
                            print 'ERROR: Processing "%s" for %s' % (content['url'],content['group']) 
            #fp.write()
        finally:
            fp.close()
 

if __name__ == "__main__":

    try:
        opts, args = getopt.getopt(sys.argv[1:], "c:arqhv", ["config=", "authzdb","vorolemap","query", "help","version"])
    except:
        print "\nUnrecognised Options"
        print "Please check the command line options"
        usage()
        sys.exit(1)
    configFile = "dcacheVoms2Gplasma.conf"
    queryVoms = False
    tasks = []
    for o, a in opts:
        if o in ("-h", "--help"):
            usage()
            sys.exit(0)
        if o in ("-v", "--version"):
            cvsTag = "$Name: not supported by cvs2svn $"
            cvsTag = cvsTag[7:-2]
            if cvsTag == "": 
                cvsTag = "Development"
                print "dcacheVoms2Gplasma.py version: " + cvsTag
            sys.exit(0)
        if o in ("-c", "--config"):
            configFile = a
        if o in ("-a", "--authzdb"):
            tasks.append("authzdb")
        if o in ("-r", "--vorolemap"):
            tasks.append("vorolemap")
        if o in ("-q", "--queryvoms"):
            queryVoms = True
    if not os.path.isfile(configFile):
        usage()
        print
        print "ERROR: config file '%s' not found" % (configFile)
        sys.exit(1)
    if len(tasks) == 0:
        usage()
        print
        print "This command should generate a authzdb or a vorolemap."
        sys.exit(0)
    cfg = configfile()
    cfg.propFileNameSet(configFile)
    
    if "authzdb" in tasks:
        authz = authzdb()
        authz.propCfgSet(cfg) 
        authz.propFileNameSet(cfg.propFileNameAuthzDbGet())
        authz.generate()   
    if "vorolemap" in tasks:
        rolemap = vorolemap()
        rolemap.propCfgSet(cfg)
        rolemap.propFileNameSet(cfg.propFileNameVoRolemapGet())
        rolemap.queryVoms = queryVoms
        rolemap.generate()
