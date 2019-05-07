﻿using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Bot.Builder.LanguageGeneration
{
    /// <summary>
    /// Here is a data model that can easily understanded and used as the context or all kinds of visitors
    /// wether it's evalator, static checker, anayler.. etc.
    /// </summary>
    public class LGTemplate
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="LGTemplate"/> class.
        /// </summary>
        /// <param name="parseTree">The parse tree of this template.</param>
        /// <param name="source">Source of this template.</param>
        public LGTemplate(LGFileParser.TemplateDefinitionContext parseTree, string source = "")
        {
            ParseTree = parseTree;
            Source = source;
            Name = ExtractName(parseTree);
            Paramters = ExtractParameters(parseTree);
        }

        /// <summary>
        /// Gets name of the template, what's followed by '#' in a LG file.
        /// </summary>
        /// <value>
        /// Name of the template, what's followed by '#' in a LG file.
        /// </value>
        public string Name { get; }

        /// <summary>
        /// Gets paramter list of this template.
        /// </summary>
        /// <value>
        /// Paramter list of this template.
        /// </value>
        public List<string> Paramters { get; }

        /// <summary>
        /// Gets source of this template, source file path if it's from a certain file.
        /// </summary>
        /// <value>
        /// Source of this template, source file path if it's from a certain file.
        /// </value>
        public string Source { get; }

        /// <summary>
        /// Gets the parse tree of this template.
        /// </summary>
        /// <value>
        /// The parse tree of this template.
        /// </value>
        public LGFileParser.TemplateDefinitionContext ParseTree { get; }

        private string ExtractName(LGFileParser.TemplateDefinitionContext parseTree) => parseTree.templateNameLine().templateName().GetText();

        private List<string> ExtractParameters(LGFileParser.TemplateDefinitionContext parseTree)
        {
            var parameters = parseTree.templateNameLine().parameters();
            if (parameters != null)
            {
                return parameters.IDENTIFIER().Select(param => param.GetText()).ToList();
            }

            return new List<string>();
        }
    }
}
