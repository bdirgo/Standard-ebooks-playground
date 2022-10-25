let testOpf = """
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://www.idpf.org/2007/opf" dir="ltr" prefix="se: https://standardebooks.org/vocab/1.0" unique-identifier="uid" version="3.0" xml:lang="en-US">
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
        <dc:identifier id="uid">url:https://standardebooks.org/ebooks/joseph-conrad/heart-of-darkness</dc:identifier>
        <dc:date>2014-05-25T00:00:00Z</dc:date>
        <meta property="dcterms:modified">2014-05-25T00:00:00Z</meta>
        <dc:rights>The source text and artwork in this ebook are believed to be in the United States public domain; that is, they are believed to be free of copyright restrictions in the United States. They may still be copyrighted in other countries, so users located outside of the United States must check their local laws before using this ebook. The creators of, and contributors to, this ebook dedicate their contributions to the worldwide public domain via the terms in the [CC0 1.0 Universal Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/).</dc:rights>
        <dc:publisher id="publisher">Standard Ebooks</dc:publisher>
        <meta property="file-as" refines="#publisher">Standard Ebooks</meta>
        <meta property="se:url.homepage" refines="#publisher">https://standardebooks.org</meta>
        <meta property="se:role" refines="#publisher" scheme="marc:relators">bkd</meta>
        <meta property="se:role" refines="#publisher" scheme="marc:relators">mdc</meta>
        <meta property="se:role" refines="#publisher" scheme="marc:relators">pbl</meta>
        <dc:contributor id="type-designer">The League of Moveable Type</dc:contributor>
        <meta property="file-as" refines="#type-designer">League of Moveable Type, The</meta>
        <meta property="se:url.homepage" refines="#type-designer">https://www.theleagueofmoveabletype.com</meta>
        <meta property="role" refines="#type-designer" scheme="marc:relators">tyd</meta>
        <link href="http://www.idpf.org/epub/a11y/accessibility-20170105.html#wcag-aa" rel="dcterms:conformsTo"/>
        <meta property="a11y:certifiedBy">Standard Ebooks</meta>
        <meta property="schema:accessMode">textual</meta>
        <meta property="schema:accessModeSufficient">textual</meta>
        <meta property="schema:accessibilityFeature">readingOrder</meta>
        <meta property="schema:accessibilityFeature">structuralNavigation</meta>
        <meta property="schema:accessibilityFeature">tableOfContents</meta>
        <meta property="schema:accessibilityFeature">unlocked</meta>
        <meta property="schema:accessibilityHazard">none</meta>
        <meta property="schema:accessibilitySummary">This publication conforms to WCAG 2.1 Level AA.</meta>
        <link href="onix.xml" media-type="application/xml" properties="onix" rel="record"/>
        <dc:title id="title">Heart of Darkness</dc:title>
        <meta property="file-as" refines="#title">Heart of Darkness</meta>
        <dc:subject id="subject-1">Europeans--Africa--Fiction</dc:subject>
        <dc:subject id="subject-2">Trading posts--Fiction</dc:subject>
        <dc:subject id="subject-3">Degeneration--Fiction</dc:subject>
        <dc:subject id="subject-4">Imperialism--Fiction</dc:subject>
        <dc:subject id="subject-5">Africa--Fiction</dc:subject>
        <meta property="authority" refines="#subject-1">LCSH</meta>
        <meta property="term" refines="#subject-1">sh2008119942</meta>
        <meta property="authority" refines="#subject-2">LCSH</meta>
        <meta property="term" refines="#subject-2">sh2010116792</meta>
        <meta property="authority" refines="#subject-3">LCSH</meta>
        <meta property="term" refines="#subject-3">sh2009123095</meta>
        <meta property="authority" refines="#subject-4">LCSH</meta>
        <meta property="term" refines="#subject-4">sh2008104273</meta>
        <meta property="authority" refines="#subject-5">LCSH</meta>
        <meta property="term" refines="#subject-5">sh2007101346</meta>
        <meta property="se:subject">Fiction</meta>
        <meta id="collection-1" property="belongs-to-collection">Modern Library’s 100 Best Novels</meta>
        <meta property="collection-type" refines="#collection-1">set</meta>
        <meta property="group-position" refines="#collection-1">67</meta>
        <meta id="collection-2" property="belongs-to-collection">The Guardian’s Best 100 Novels in English (2015)</meta>
        <meta property="collection-type" refines="#collection-2">set</meta>
        <meta property="group-position" refines="#collection-2">32</meta>
        <meta id="collection-3" property="belongs-to-collection">The BBC’s 100 Greatest British Novels (2015)</meta>
        <meta property="collection-type" refines="#collection-3">set</meta>
        <meta property="group-position" refines="#collection-3">21</meta>
        <meta id="collection-4" property="belongs-to-collection">The Telegraph’s Greatest Villains in Literature</meta>
        <meta property="collection-type" refines="#collection-4">set</meta>
        <meta property="group-position" refines="#collection-4">9</meta>
        <meta id="collection-5" property="belongs-to-collection">Encyclopædia Britannica’s Great Books of the Western World</meta>
        <meta property="collection-type" refines="#collection-5">set</meta>
        <dc:description id="description">A steamer captain in the heart of Africa witnesses the final days of a brutal ivory trader.</dc:description>
        <meta id="long-description" property="se:long-description" refines="#description">
            &lt;p&gt;Originally published serially as a three-part story, &lt;i&gt;Heart of Darkness&lt;/i&gt; is a short but thematically complex novel exploring colonialism, humanity, and what constitutes a savage society. Set in the Congo in Central Africa, the tale is told in the frame of the recollections of one Charles Marlow, a captain of an ivory steamer. Marlow’s search for the mysterious and powerful “first-class agent” Kurtz gives way to a nuanced and powerful commentary on the horrors of colonialism, called by some the most analyzed work at university-level instruction.&lt;/p&gt;
        </meta>
        <dc:language>en-US</dc:language>
        <dc:source>https://www.gutenberg.org/ebooks/219</dc:source>
        <meta property="se:word-count">38792</meta>
        <meta property="se:reading-ease.flesch">71.34</meta>
        <meta property="se:url.encyclopedia.wikipedia">https://en.wikipedia.org/wiki/Heart_of_Darkness</meta>
        <meta property="se:url.vcs.github">https://github.com/standardebooks/joseph-conrad_heart-of-darkness</meta>
        <dc:creator id="author">Joseph Conrad</dc:creator>
        <meta property="file-as" refines="#author">Conrad, Joseph</meta>
        <meta property="se:name.person.full-name" refines="#author">Józef Teodor Konrad Korzeniowski</meta>
        <meta property="se:url.encyclopedia.wikipedia" refines="#author">https://en.wikipedia.org/wiki/Joseph_conrad</meta>
        <meta property="se:url.authority.nacoaf" refines="#author">http://id.loc.gov/authorities/names/n79054067</meta>
        <meta property="role" refines="#author" scheme="marc:relators">aut</meta>
        <dc:contributor id="artist">William Michaud von Vevey</dc:contributor>
        <meta property="file-as" refines="#artist">Vevey, William Michaud von</meta>
        <meta property="role" refines="#artist" scheme="marc:relators">art</meta>
        <dc:contributor id="transcriber-1">Judith Boss</dc:contributor>
        <meta property="file-as" refines="#transcriber-1">Boss, Judith</meta>
        <meta property="role" refines="#transcriber-1" scheme="marc:relators">trc</meta>
        <dc:contributor id="transcriber-2">David Widger</dc:contributor>
        <meta property="file-as" refines="#transcriber-2">Widger, David</meta>
        <meta property="se:url.authority.nacoaf" refines="#transcriber-2">http://id.loc.gov/authorities/names/no2011017869</meta>
        <meta property="role" refines="#transcriber-2" scheme="marc:relators">trc</meta>
        <dc:contributor id="producer-1">Alex Cabal</dc:contributor>
        <meta property="file-as" refines="#producer-1">Cabal, Alex</meta>
        <meta property="se:url.homepage" refines="#producer-1">https://alexcabal.com</meta>
        <meta property="role" refines="#producer-1" scheme="marc:relators">bkp</meta>
        <meta property="se:role" refines="#producer-1" scheme="marc:relators">blw</meta>
        <meta property="se:role" refines="#producer-1" scheme="marc:relators">cov</meta>
        <meta property="se:role" refines="#producer-1" scheme="marc:relators">mrk</meta>
        <meta property="se:role" refines="#producer-1" scheme="marc:relators">pfr</meta>
        <meta property="se:role" refines="#producer-1" scheme="marc:relators">tyg</meta>
    </metadata>
    <manifest>
        <item href="css/core.css" id="core.css" media-type="text/css"/>
        <item href="css/local.css" id="local.css" media-type="text/css"/>
        <item href="css/se.css" id="se.css" media-type="text/css"/>
        <item href="images/cover.svg" id="cover.svg" media-type="image/svg+xml" properties="cover-image"/>
        <item href="images/logo.svg" id="logo.svg" media-type="image/svg+xml"/>
        <item href="images/titlepage.svg" id="titlepage.svg" media-type="image/svg+xml"/>
        <item href="text/colophon.xhtml" id="colophon.xhtml" media-type="application/xhtml+xml" properties="svg"/>
        <item href="text/imprint.xhtml" id="imprint.xhtml" media-type="application/xhtml+xml" properties="svg"/>
        <item href="text/part-1.xhtml" id="part-1.xhtml" media-type="application/xhtml+xml"/>
        <item href="text/part-2.xhtml" id="part-2.xhtml" media-type="application/xhtml+xml"/>
        <item href="text/part-3.xhtml" id="part-3.xhtml" media-type="application/xhtml+xml"/>
        <item href="text/titlepage.xhtml" id="titlepage.xhtml" media-type="application/xhtml+xml" properties="svg"/>
        <item href="text/uncopyright.xhtml" id="uncopyright.xhtml" media-type="application/xhtml+xml"/>
        <item href="toc.xhtml" id="toc.xhtml" media-type="application/xhtml+xml" properties="nav"/>
    </manifest>
    <spine>
        <itemref idref="titlepage.xhtml"/>
        <itemref idref="imprint.xhtml"/>
        <itemref idref="part-1.xhtml"/>
        <itemref idref="part-2.xhtml"/>
        <itemref idref="part-3.xhtml"/>
        <itemref idref="colophon.xhtml"/>
        <itemref idref="uncopyright.xhtml"/>
    </spine>
</package>
"""
