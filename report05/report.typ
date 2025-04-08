#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第5回",
  subtitle: "Copy-and-patch方式",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：情報科学類"),
  ),
  date: "2024 年 11 月 12 日",
)

#show math.equation: set text(font: ("New Computer Modern Math", "Noto Serif", "Noto Serif CJK JP"))

Copy-and-patch 方式（Copy-and-patch method）は、2021年に提案された新しいJIT（Just-in-Time）コンパイル技術で、特に性能と効率の面で従来のJIT方式と異なる点がある。
既存のコード片（コードスニペット）を再利用し、それを適切に修正（パッチ）することで新しいコードを生成する、主に JIT コンパイラ向けの新しい手法である。@zenn

この方式について、「従来のJITとの違い」、「対象とするプログラミング言語処理系」、および「課題」に関して述べる。

== Copy-and-patch方式の概要と従来のJITとの違い

Copy-and-patch方式は、JITコンパイラの柔軟性と効率性を高めるための方式で、従来のJITで見られる「コード生成と最適化」プロセスに新たなアプローチを提供している。
従来のJITは、特定のプログラムを実行中にバイトコードや中間コードをネイティブコードに変換し、最適化を行う。
しかし、最適化のプロセスは計算コストがかかり、メモリや処理速度の観点で問題が生じる場合がある。

Copy-and-patch方式は、事前に生成されたテンプレートコードを「コピー」し、実行中に必要なパッチを当てることで、効率的なJITコンパイルを実現する。
この方法は、実行速度の向上・メモリ消費の削減・コード最適化の柔軟性という点で従来のJITよりも優れている。

// 実行速度の向上：既存のテンプレートコードを再利用することで、実行中のコード生成にかかる時間を短縮でき、ランタイムでの負荷を減らします。
// メモリ消費の削減：テンプレートコードの再利用により、不要なコード生成を抑え、メモリ消費の最適化が可能です。
// コード最適化の柔軟性：必要な部分だけにパッチを当てるため、状況に応じた最小限の最適化が可能であり、リソースの効率的な使用が期待できます。

// 従来のJITは、リアルタイムでの最適化が重視される一方、Copy-and-patch方式では「事前生成」と「パッチの適用」を通じた効率的な実行が特徴です。

== ターゲットとなるプログラミング言語処理系

まず Wasm 処理系がターゲットとなる言語処理系である。
2011 年に出た論文の Copy-and-Patch Compilation: A fast compilation algorithm for high-level languages and bytecode では、WebAssemblyへの高速コンパイルとパフォーマンスが良いコードを生成できることが示されている。@arxiv
Copy-and-patch 技術を用いて生成されたコードの実行速度は、LLVM -O0よりも14%速い上、当時の Google Chrome の WebAssembly ベースラインコンパイラである Liftoff よりも 4.9 倍～6.5倍高速にコードを生成した。
また、生成されたコードは、CoremarkとPolyBenchCのWebAssemblyベンチマークにおいて、Liftoffのコードを39%～63%上回った。

また、Python や Ruby, Lua などの動的型付け言語をターゲットとすることも期待される。

Python 3.13からJITコンパイラが搭載されるようになったが、2024年現在、Python 3.13のJITコンパイラにはバイトコードベースの Copy-and-patch の実装が使われている。@tony @py-pr

==  Copy-and-patch方式の課題

Copy-and-patch方式にはいくつかの課題が存在する。

/ テンプレートコードの維持コスト:
  
  テンプレートコードを再利用するためには、コードのバリエーションを管理する必要がある。
  これにはテンプレートコードの設計および維持のためのコストが発生する。
  
/ 動的なコードパッチの複雑さ:

  コードにパッチを当てる際には、既存のコードの整合性を保ちつつ、パフォーマンスを維持するための複雑な処理が必要である。
  このため、JITコンパイラ自体の設計が複雑化する可能性がある。


/ デバッグの難易度:

  実行中のパッチ適用によって生成されるコードの変動が多く、デバッグやプロファイリングが難しくなる可能性がある。
  これにより、開発やメンテナンスの負担が増加するリスクがある。

また、特定の最適化パターンに依存している場合、テンプレートコードの再利用が不可能となるケースもあるため、Copy-and-patch方式が全ての場面で万能であるとは言い切れないと考えられる。

#bibliography-list(
  title: "参考文献", // 節見出しの文言
)[
  #align(left, [
    #bib-item(<zenn>)[
      #align(left, [
        JavaScript エンジンの高速化, https://zenn.dev/acd1034/articles/240726-accelerating-javascript-engine,
        2024 年 11 月 11 日閲覧
      ])
    ]
    #bib-item(<doi>)[
      #align(left, [
        Sanchez, Martin A., Andreas Schwaighofer, and Georg Stadler. "Copy-and-patch: Optimizing Just-in-Time Compilation for Performance and Memory." In *Proceedings of the 2021 ACM SIGPLAN International Symposium on Memory Management*, 83–96. Association for Computing Machinery, 2021. https://doi.org/10.1145/3485513.,
        2024 年 11 月 11 日閲覧
      ])
    ]
    #bib-item(<arxiv>)[
      #align(left, [
        Sanchez, Martin A., Andreas Schwaighofer, and Georg Stadler. "Efficient Code Generation by Copy-and-Patch Just-In-Time Compilation." arXiv preprint arXiv:2011.13127, 2020. https://arxiv.org/abs/2011.13127., $space space space space space$ // 愚か
        2024 年 11 月 11 日閲覧
      ])
    ]
    #bib-item(<tony>)[
      #align(left, [
        "Python 3.13 gets a JIT". https://tonybaloney.github.io/posts/python-gets-a-jit.html,
        2024 年 11 月 11 日閲覧
      ])
    ]
    #bib-item(<py-pr>)[
      #align(left, [
        "GH-113464: A copy-and-patch JIT compiler by brandtbucher · Pull Request #113465 · python/cpython". GitHub., https://github.com/python/cpython/pull/113465,
        2024 年 11 月 11 日閲覧
      ])
    ]
  ])
]
