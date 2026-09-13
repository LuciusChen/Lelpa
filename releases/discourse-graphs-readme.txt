Discourse Graph is a knowledge synthesis tool for Emacs org-mode.
It implements the discourse graph protocol for organizing research notes
into semantic units (Questions, Claims, Evidence, Sources) with typed
relationships (supports, opposes, informs, answers).

Based on the Discourse Graph protocol by Joel Chan for Roam Research.
See: https://github.com/joelchan/roam-discourse-graph

Features:
- SQLite-backed storage for scalability
- Compatible with denote file naming and linking
- Discourse Context sidebar with expandable summaries
- Computed attributes (support count, evidence score)
- Interactive query builder with save/load
- Transient-based menu system
- Context overlay showing relation counts
- Export to Graphviz SVG and Markdown

Quick Start:
  (require 'discourse-graphs)
  (setq dg-directories '("~/org/research/"))
  (discourse-graphs-mode 1)
  M-x dg-menu  or  C-c d d

Node Types:
  - Question (QUE): Research questions to explore
  - Claim (CLM): Assertions or arguments
  - Evidence (EVD): Supporting data or observations
  - Source (SRC): References and citations

Relation Types:
  - supports: Evidence/Claim supports a Claim
  - opposes: Evidence/Claim opposes a Claim
  - informs: Provides background, context, or source reference
             (use for Evidence → Source connections)
  - answers: Claim answers a Question
