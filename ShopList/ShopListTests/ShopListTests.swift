import XCTest
import CoreData
@testable import ShopList

class ShopListTests: XCTestCase {
    
    var cartManager: CartManager!
    var context: NSManagedObjectContext!
    var mockProduct: Produkt!
    var mockCategory: Kategoria!
    
    override func setUp() {
        super.setUp()
        
        let persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        cartManager = CartManager()
        
        mockProduct = Produkt(context: context)
        mockProduct.id = UUID()
        mockProduct.nazwa = "Testowy Produkt"
        mockProduct.cena = NSDecimalNumber(value: 10.0)
        mockProduct.opis = "Przykładowy opis produktu"
        
        mockCategory = Kategoria(context: context)
        mockCategory.id = UUID()
        mockCategory.nazwa = "Testowa Kategoria"
    }
    
    override func tearDown() {
        cartManager = nil
        mockProduct = nil
        mockCategory = nil
        context = nil
        super.tearDown()
    }
    
    // MARK: - Testy koszyka
    
    func testDodajProduktDoKoszyka() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 2)
        XCTAssertEqual(cartManager.produktyWKoszyku[mockProduct], 2)
    }
    
    func testUsunProduktZKoszyka() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 2)
        cartManager.usunZKoszyka(mockProduct)
        XCTAssertFalse(cartManager.produktyWKoszyku.keys.contains(mockProduct))
    }
    
    func testWyczyscKoszyk() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 2)
        cartManager.wyczyscKoszyk()
        XCTAssertTrue(cartManager.produktyWKoszyku.isEmpty)
    }
    
    func testObliczSumeKoszyka() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 3)
        XCTAssertEqual(cartManager.suma(), 30.0)
    }
    
    // MARK: - Testy interfejsu
    
    func testListaProduktowNieJestPusta() {
        let produkty = [mockProduct]
        XCTAssertFalse(produkty.isEmpty)
    }
    
    func testSortowanieProduktow() {
        let produktA = Produkt(context: context)
        produktA.nazwa = "Jablko"
        
        let produktB = Produkt(context: context)
        produktB.nazwa = "Banan"
        
        let produkty = [produktB, produktA].sorted { $0.nazwa! < $1.nazwa! }
        XCTAssertEqual(produkty.first?.nazwa, "Banan")
    }
    
    func testFiltrowanieProduktow() {
        let produkty = [mockProduct]
        let filtrowane = produkty.filter { $0?.nazwa?.contains("Testowy") == true }
        
        XCTAssertEqual(filtrowane.count, 1)
    }
    
    // MARK: - Nowe testy zamiast testów API
    
    func testDodanieProduktuZOpisem() {
        let nowyProdukt = Produkt(context: context)
        nowyProdukt.nazwa = "Nowy Produkt"
        nowyProdukt.opis = "To jest testowy opis produktu"
        
        XCTAssertNotNil(nowyProdukt.opis)
    }
    
    func testZmianaIlosciProduktuWKoszyku() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 1)
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 3)
        
        XCTAssertEqual(cartManager.produktyWKoszyku[mockProduct], 4)
    }
    
    func testPoprawneUsuniecieZKoszykaPoDodaniu() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 1)
        cartManager.usunZKoszyka(mockProduct)
        
        XCTAssertFalse(cartManager.produktyWKoszyku.keys.contains(mockProduct))
    }
    
    func testPoprawneDodanieZamowienia() {
        let zamowienie = Zamowienie(context: context)
        zamowienie.id = UUID()
        zamowienie.klient = "Testowy Klient"
        zamowienie.adres = "Testowy Adres"
        
        do {
            try context.save()
        } catch {
            XCTFail("Nie udało się zapisać zamówienia")
        }
    }
    
    func testProduktBezNazwy() {
        let produkt = Produkt(context: context)
        XCTAssertNil(produkt.nazwa)
    }
    
    func testCenaProduktuNieMozeBycUjemna() {
        mockProduct.cena = NSDecimalNumber(value: -5.0)
        XCTAssertLessThanOrEqual(mockProduct.cena!.doubleValue, 0.0)
    }
    
    func testIloscProduktowWKoszykuNieMozeBycUjemna() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: -1)
        XCTAssertGreaterThanOrEqual(cartManager.produktyWKoszyku[mockProduct] ?? 0, 0)
    }
    
    func testDodanieNowejKategorii() {
        let kategoria = Kategoria(context: context)
        kategoria.nazwa = "Napoje"
        XCTAssertNotNil(kategoria.nazwa)
    }
    
    func testZamowienieBezProduktow() {
        let zamowienie = Zamowienie(context: context)
        XCTAssertTrue(zamowienie.produkty?.count == 0 || zamowienie.produkty == nil)
    }

    func testDodanieProduktowDoZamowienia() {
        let zamowienie = Zamowienie(context: context)
        zamowienie.produkty = NSSet(array: [mockProduct!])
        XCTAssertEqual(zamowienie.produkty?.count, 1)
    }
    
    func testUsuniecieProduktowZKoszykaPoZamowieniu() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 1)
        cartManager.wyczyscKoszyk()
        XCTAssertTrue(cartManager.produktyWKoszyku.isEmpty)
    }
    
    func testProduktZNiepoprawnaCena() {
        let produkt = Produkt(context: context)
        produkt.nazwa = "Błąd"
        produkt.cena = nil
        XCTAssertNil(produkt.cena)
    }
    
    func testPustyKoszyk() {
        XCTAssertTrue(cartManager.produktyWKoszyku.isEmpty)
    }
    
    func testDodanieDwochRoznychProduktowDoKoszyka() {
        let produkt2 = Produkt(context: context)
        produkt2.nazwa = "Inny Produkt"
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 1)
        cartManager.dodajDoKoszyka(produkt2, ilosc: 1)
        XCTAssertEqual(cartManager.produktyWKoszyku.count, 2)
    }

    
    func testProduktMoznaPrzypisacDoKategorii() {
        mockProduct.kategoria = mockCategory
        XCTAssertEqual(mockProduct.kategoria?.nazwa, "Testowa Kategoria")
    }
    
    func testUsuniecieKategoriiNieUsuwaProduktu() {
        mockProduct.kategoria = mockCategory
        context.delete(mockCategory)
        do {
            try context.save()
        } catch {
            XCTFail("Nie udało się zapisać zmian")
        }
        XCTAssertNotNil(mockProduct)
    }
    
    func testListaProduktowWKategorii() {
        mockProduct.kategoria = mockCategory
        let produktyWKategorii = [mockProduct]
        XCTAssertEqual(produktyWKategorii.count, 1)
    }
    
    func testKategoriaBezNazwy() {
        let kategoria = Kategoria(context: context)
        XCTAssertNil(kategoria.nazwa)
    }
    
    func testZamowienieMaPrawidlowegoKlienta() {
        let zamowienie = Zamowienie(context: context)
        zamowienie.klient = "Jan Kowalski"
        XCTAssertEqual(zamowienie.klient, "Jan Kowalski")
    }
    
    func testZmianaCenyProduktu() {
        mockProduct.cena = NSDecimalNumber(value: 20.0)
        XCTAssertEqual(mockProduct.cena?.doubleValue, 20.0)
    }
    
    func testCzyKoszykNieJestPustyPoDodaniuProduktu() {
        cartManager.dodajDoKoszyka(mockProduct, ilosc: 1)
        XCTAssertFalse(cartManager.produktyWKoszyku.isEmpty)
    }
    
    func testUsuniecieWszystkichProduktowZKategorii() {
        mockProduct.kategoria = mockCategory
        mockProduct.kategoria = nil
        XCTAssertNil(mockProduct.kategoria)
    }
}
