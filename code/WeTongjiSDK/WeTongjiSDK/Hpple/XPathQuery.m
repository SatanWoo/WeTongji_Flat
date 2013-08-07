//
//  XPathQuery.m
//  FuelFinder
//
//  Created by Matt Gallagher on 4/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "XPathQuery.h"

#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

NSDictionary *DictionaryForNode(xmlNodePtr currentNode, NSMutableDictionary *parentResult,BOOL parentContent);
NSArray *PerformXPathQuery(xmlDocPtr doc, NSString *query);

NSDictionary *DictionaryForNode(xmlNodePtr currentNode, NSMutableDictionary *parentResult,BOOL parentContent)
{
  NSMutableDictionary *resultForNode = [NSMutableDictionary dictionary];

  if (currentNode->name)
    {
      NSString *currentNodeContent =
        @((const char *)currentNode->name);
      resultForNode[@"nodeName"] = currentNodeContent;
    }

  if (currentNode->content && currentNode->content != (xmlChar *)-1)
    {
      NSString *currentNodeContent =
        @((const char *)currentNode->content);

      if ([resultForNode[@"nodeName"] isEqual:@"text"] && parentResult)
        {
            if (parentContent)
            {
                parentResult[@"nodeContent"] = [currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return nil;
            }
            resultForNode[@"nodeContent"] = currentNodeContent;
//            NSLog(@"content: %@",currentNodeContent);
            return resultForNode;

        }
      else {
          resultForNode[@"nodeContent"] = currentNodeContent;          
      }


    }

  xmlAttr *attribute = currentNode->properties;
  if (attribute)
    {
      NSMutableArray *attributeArray = [NSMutableArray array];
      while (attribute)
        {
          NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
          NSString *attributeName =
            @((const char *)attribute->name);
          if (attributeName)
            {
//                NSLog(@"Attribute Name Set: %@",attributeName);
              attributeDictionary[@"attributeName"] = attributeName;
            }

          if (attribute->children)
            {
              NSDictionary *childDictionary = DictionaryForNode(attribute->children, attributeDictionary,true);
              if (childDictionary)
                {
                  attributeDictionary[@"attributeContent"] = childDictionary;
                }
            }

          if ([attributeDictionary count] > 0)
            {
              [attributeArray addObject:attributeDictionary];
            }
          attribute = attribute->next;
        }

      if ([attributeArray count] > 0)
        {
          resultForNode[@"nodeAttributeArray"] = attributeArray;
        }
    }

  xmlNodePtr childNode = currentNode->children;
  if (childNode)
    {
      NSMutableArray *childContentArray = [NSMutableArray array];
      while (childNode)
        {
          NSDictionary *childDictionary = DictionaryForNode(childNode, resultForNode,false);
          if (childDictionary)
            {
              [childContentArray addObject:childDictionary];
            }
          childNode = childNode->next;
        }
      if ([childContentArray count] > 0)
        {
          resultForNode[@"nodeChildArray"] = childContentArray;
        }
    }

  return resultForNode;
}

NSArray *PerformXPathQuery(xmlDocPtr doc, NSString *query)
{
  xmlXPathContextPtr xpathCtx;
  xmlXPathObjectPtr xpathObj;

  /* Create xpath evaluation context */
  xpathCtx = xmlXPathNewContext(doc);
  if (xpathCtx == NULL)
    {
      NSLog(@"Unable to create XPath context.");
      return nil;
    }

  /* Evaluate xpath expression */
  xpathObj = xmlXPathEvalExpression((xmlChar *)[query cStringUsingEncoding:NSUTF8StringEncoding], xpathCtx);
  if (xpathObj == NULL) {
    NSLog(@"Unable to evaluate XPath.");
    xmlXPathFreeContext(xpathCtx);
    return nil;
  }

  xmlNodeSetPtr nodes = xpathObj->nodesetval;
  if (!nodes)
    {
      NSLog(@"Nodes was nil.");
      xmlXPathFreeObject(xpathObj);
      xmlXPathFreeContext(xpathCtx);
      return nil;
    }

  NSMutableArray *resultNodes = [NSMutableArray array];
  for (NSInteger i = 0; i < nodes->nodeNr; i++)
    {
      NSDictionary *nodeDictionary = DictionaryForNode(nodes->nodeTab[i], nil,false);
      if (nodeDictionary)
        {
          [resultNodes addObject:nodeDictionary];
        }
    }

  /* Cleanup */
  xmlXPathFreeObject(xpathObj);
  xmlXPathFreeContext(xpathCtx);

  return resultNodes;
}

NSArray *PerformHTMLXPathQuery(NSData *document, NSString *query)
{
  xmlDocPtr doc;

  /* Load XML document */
  doc = htmlReadMemory([document bytes], (int)[document length], "", NULL, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);

  if (doc == NULL)
    {
      NSLog(@"Unable to parse.");
      return nil;
    }

  NSArray *result = PerformXPathQuery(doc, query);
  xmlFreeDoc(doc);

  return result;
}

NSArray *PerformXMLXPathQuery(NSData *document, NSString *query)
{
  xmlDocPtr doc;

  /* Load XML document */
  doc = xmlReadMemory([document bytes], (int)[document length], "", NULL, XML_PARSE_RECOVER);

  if (doc == NULL)
    {
      NSLog(@"Unable to parse.");
      return nil;
    }

  NSArray *result = PerformXPathQuery(doc, query);
  xmlFreeDoc(doc);

  return result;
}
