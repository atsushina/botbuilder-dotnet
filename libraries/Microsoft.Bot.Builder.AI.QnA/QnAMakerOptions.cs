﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Newtonsoft.Json;

namespace Microsoft.Bot.Builder.AI.QnA
{
    /// <summary>
    /// Defines options for the QnA Maker knowledge base.
    /// </summary>
    public class QnAMakerOptions
    {
        public QnAMakerOptions()
        {
            ScoreThreshold = 0.3f;
        }

        /// <summary>
        /// Gets or sets the minimum score threshold, used to filter returned results.
        /// </summary>
        /// <remarks>Scores are normalized to the range of 0.0 to 1.0
        /// before filtering.</remarks>
        /// <value>
        /// The minimum score threshold, used to filter returned results.
        /// </value>
        [JsonProperty("scoreThreshold")]
        public float ScoreThreshold { get; set; }

        /// <summary>
        /// Gets or sets the number of ranked results you want in the output.
        /// </summary>
        /// <value>
        /// The number of ranked results you want in the output.
        /// </value>
        [JsonProperty("top")]
        public int Top { get; set; }

        [JsonProperty("strictFilters")]
        public Metadata[] StrictFilters { get; set; }

        [JsonProperty("metadataBoost")]
        public Metadata[] MetadataBoost { get; set; }
    }
}
