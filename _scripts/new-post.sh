#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 \"Post Title\""
  exit 1
fi

title="$*"
slug="$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
if [ -z "$slug" ]; then
  echo "Could not create a slug from title: $title"
  exit 1
fi

post_date="$(date +%F)"
post_timestamp="$(date '+%Y-%m-%d %H:%M:%S %z')"
target="_posts/${post_date}-${slug}.md"

if [ -e "$target" ]; then
  echo "Refusing to overwrite existing file: $target"
  exit 1
fi

mkdir -p _posts

cat > "$target" <<TEMPLATE
---
layout: post
title: "$title"
date: $post_timestamp
description: ""
tags: []
categories: [research-notes]
giscus_comments: true
toc:
  sidebar: left
---

Write your post here.

Inline math with your macros works, e.g. \$\\mbR^3\$, \$\\pp{f}{x}\$, \$\\wh{\\mcE}\$.

\$\$
\\dd{g}{s} = g\\,\\wh{\\mcE}.
\$\$
TEMPLATE

echo "Created $target"
