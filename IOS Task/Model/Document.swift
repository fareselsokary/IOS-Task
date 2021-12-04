//
//  Document.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

// MARK: - Document

struct Document: Codable {
    var key: String?
    var type: String?
    var seed: [String]?
    var title, titleSuggest: String?
    var hasFulltext: Bool?
    var editionCount: Int?
    var editionKey, publishDate: [String]?
    var publishYear: [Int]?
    var firstPublishYear, numberOfPagesMedian: Int?
    var lccn, publishPlace, oclc, contributor: [String]?
    var lcc, ddc, isbn: [String]?
    var lastModifiedI, ebookCountI: Int?
    var ia: [String]?
    var publicScanB: Bool?
    var iaCollectionS, lendingEditionS, lendingIdentifierS, printdisabledS: String?
    var coverEditionKey: String?
    var coverI: Int?
    var firstSentence, publisher, language, authorKey: [String]?
    var authorName, authorAlternativeName, person, place: [String]?
    var subject, time, idAlibrisID, idAmazon: [String]?
    var idBcid, idDepósitoLegal, idDnb, idGoodreads: [String]?
    var idGoogle, idLibrarything, idLibris, idOverdrive: [String]?
    var idWikidata, iaLoadedID, iaBoxID, publisherFacet: [String]?
    var personKey, placeKey, timeFacet, personFacet: [String]?
    var subjectFacet: [String]?
    var version: Double?
    var placeFacet: [String]?
    var lccSort: String?
    var authorFacet, subjectKey: [String]?
    var ddcSort: String?
    var timeKey, idAmazonCAAsin, idAmazonCoUkAsin, idAmazonDeAsin: [String]?
    var idAmazonItAsin, idBritishNationalBibliography, idNla, idPaperbackSwap: [String]?
    var idBibliothèqueNationaleDeFranceBnf, idBritishLibrary, idHathiTrust, idScribd: [String]?
    var idCanadianNationalLibraryArchive: [String]?
    var subtitle: String?

    enum CodingKeys: String, CodingKey {
        case key, type, seed, title
        case titleSuggest = "title_suggest"
        case hasFulltext = "has_fulltext"
        case editionCount = "edition_count"
        case editionKey = "edition_key"
        case publishDate = "publish_date"
        case publishYear = "publish_year"
        case firstPublishYear = "first_publish_year"
        case numberOfPagesMedian = "number_of_pages_median"
        case lccn
        case publishPlace = "publish_place"
        case oclc, contributor, lcc, ddc, isbn
        case lastModifiedI = "last_modified_i"
        case ebookCountI = "ebook_count_i"
        case ia
        case publicScanB = "public_scan_b"
        case iaCollectionS = "ia_collection_s"
        case lendingEditionS = "lending_edition_s"
        case lendingIdentifierS = "lending_identifier_s"
        case printdisabledS = "printdisabled_s"
        case coverEditionKey = "cover_edition_key"
        case coverI = "cover_i"
        case firstSentence = "first_sentence"
        case publisher, language
        case authorKey = "author_key"
        case authorName = "author_name"
        case authorAlternativeName = "author_alternative_name"
        case person, place, subject, time
        case idAlibrisID = "id_alibris_id"
        case idAmazon = "id_amazon"
        case idBcid = "id_bcid"
        case idDepósitoLegal = "id_depósito_legal"
        case idDnb = "id_dnb"
        case idGoodreads = "id_goodreads"
        case idGoogle = "id_google"
        case idLibrarything = "id_librarything"
        case idLibris = "id_libris"
        case idOverdrive = "id_overdrive"
        case idWikidata = "id_wikidata"
        case iaLoadedID = "ia_loaded_id"
        case iaBoxID = "ia_box_id"
        case publisherFacet = "publisher_facet"
        case personKey = "person_key"
        case placeKey = "place_key"
        case timeFacet = "time_facet"
        case personFacet = "person_facet"
        case subjectFacet = "subject_facet"
        case version = "_version_"
        case placeFacet = "place_facet"
        case lccSort = "lcc_sort"
        case authorFacet = "author_facet"
        case subjectKey = "subject_key"
        case ddcSort = "ddc_sort"
        case timeKey = "time_key"
        case idAmazonCAAsin = "id_amazon_ca_asin"
        case idAmazonCoUkAsin = "id_amazon_co_uk_asin"
        case idAmazonDeAsin = "id_amazon_de_asin"
        case idAmazonItAsin = "id_amazon_it_asin"
        case idBritishNationalBibliography = "id_british_national_bibliography"
        case idNla = "id_nla"
        case idPaperbackSwap = "id_paperback_swap"
        case idBibliothèqueNationaleDeFranceBnf = "id_bibliothèque_nationale_de_france_bnf"
        case idBritishLibrary = "id_british_library"
        case idHathiTrust = "id_hathi_trust"
        case idScribd = "id_scribd"
        case idCanadianNationalLibraryArchive = "id_canadian_national_library_archive"
        case subtitle
    }
}
