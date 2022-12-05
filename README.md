# blue-stability

`blue-stability` (`bstab`) is a fork of [stability-sdk](https://github.com/Stability-AI/stability-sdk) and an [`awesome-bash-cli`](https://github.com/kamangir/awesome-bash-cli) (`abcli`) plugin.

## Install

```bash
abcli git clone blue-stability install
blue_stability help verbose
```

![image](./assets/marquee.png)

## Sentence -> Image

```bash
blue_stability generate image \
  ~dryrun \
  carrot.png - \
  "an orange carrot walking on Mars." \
  --width 768 --height 576 \
  --seed 42 
```

![image](https://github.com/kamangir/AI-ART/blob/main/blue-stability/carrot.png?raw=true)

## Text -> Video

```bash
blue_stability generate video \
  ~dryrun,frame_count=100,marker=PART,url \
  https://www.gutenberg.org/cache/epub/51833/pg51833.txt \
  --seed 43 \
  --start_schedule 0.9
```

![blue_stability](https://github.com/kamangir/AI-ART/blob/main/blue-stability/blue_stability.gif)

## Interactive Mode

```bash
abcli select <name-of-your-script> open; \
blue_stability interactive \
  ~dryrun \
  --seed 42 \
  --start_schedule 0.9
```

Start typing your story. 📜

## Notebook

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/kamangir/blue-stability/blob/main/nbs/demo_colab.ipynb)

```bash
blue_stability notebook
```
