##  Can a Large Language Model Document a C++ Project? A Case Study with Gemini 1.5 Pro Beta and stm32plus

This document explores the potential of using large language models (LLMs) for documenting large C++ projects, specifically focusing on the Gemini 1.5 Pro  capabilities. The stm32plus project serves as a case study.

### Experiment Methodology

A curated 3.9MB selection of stm32plus source files (approximately 1.2M tokens) was fed to Gemini as context. The model was then prompted to generate documentation, resulting in:

* A structured outline encompassing core library components, peripherals, and examples.
* Initial attempts at UML diagram generation (unfortunately interrupted by a browser crash).

### Initial Observations

While each request took several minutes to process, it was significantly faster than manual documentation.  The output structure was promising, and given LLMs' tendency to avoid excessive "hallucination" when summarizing code, the documentation quality could be high.

## Cost Analysis

Although the Gemini 1.5 Pro Beta is currently free, it's valuable to estimate potential pay-as-you-go costs for this use case.

### Estimated Usage

* **Initial Outline:** 1 prompt
* **Section Documentation:** 2 prompts per section (assuming a two-level structure)
* **Diagram List:** 1 prompt
* **Diagrams:** 1 prompt per diagram

Assuming a moderate project structure, 5 prompts could suffice for basic documentation.  However, achieving comprehensive documentation would likely require more extensive prompting.

### Token Cost

The primary cost driver is the 1.2M token context, estimated at $8.4 per prompt. With a 4-minute processing time per prompt, generating the initial documentation without context caching could cost $42.

### Context Caching Impact

Context caching can significantly reduce costs by storing frequently used tokens. Since the 1.2M token codebase remains constant, caching could reduce the per-prompt cost to $2.1, resulting in a total cost of $10.5.

### Google Gemini Pricing (as of October 27, 2023)

**Pay-as-you-go (USD)**

| Feature                | Price                                    |
|------------------------|-----------------------------------------|
| Input (up to 128K tokens)  | $3.50 / 1 million tokens                |
| Input (over 128K tokens) | $7.00 / 1 million tokens                |
| Context Caching        | $0.875 / 1 million tokens (up to 128K) |
| Context Caching        | $1.75 / 1 million tokens (over 128K)  |
| Storage                | $4.50 / 1 million tokens per hour      |


### Context Caching Description

This feature allows caching input tokens for reuse, reducing costs when repeatedly referencing the same content. The cached tokens have a configurable time-to-live (TTL) after which they are deleted.  Pricing depends on the cached token count and storage duration.

**Use Cases:**

* Chatbots with extensive system instructions
* Analysis of lengthy files (e.g., videos, documents)
* Code repository analysis and bug fixing

## Conclusion

LLMs like Gemini show promise for automating C++ project documentation. While initial costs can be high due to large context sizes, context caching significantly mitigates this. Further experimentation is needed to refine prompting strategies and assess the overall quality and cost-effectiveness of LLM-generated documentation. 

However, further exploration is crucial to optimize both cost and efficiency. A key avenue lies in decomposing the project into independent context blocks. This could involve prompting the LLM itself to segment the full context or utilizing tools from the LLVM/GCC ecosystem for more precise code selection and curation. By strategically dividing the information presented to the LLM, we can minimize redundant processing, accelerate response times, and ultimately enhance the feasibility of LLM-powered documentation for large-scale software projects.