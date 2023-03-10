import UIKit
import CoreLocation

class PizzaHistoryAnnotations {
    var annotations:[PizzaAnnotation] = []
    init(){
        //Naples
        var annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(23.5880, 72.3693), title: "Pizza Margherita", subtitle: "Street Food Nationalized")
        annotation.pizzaPhoto = UIImage(named: "New York")
        annotation.historyText = "Street Food Nationalized - The legend goes that King Umberto and Queen Margherita of Italy got tired of the royal food, which was always French. Looking for both something new and something Italian, in Naples they ordered a local pizzeria to make them pizza, which was up till then poor people's food.  The Queen loved a pizza of tomatoes, fresh mozzarella and basil so much the restaurant named the pizza after her. That the pizza was the colors of the Italian flag may not be a coinicidence. To this day to sell a true Neapolitan pizza, you must be certified by an association of pizza restaurants in Naples for the process and quality of ingredients."
        self.annotations.append(annotation)
        
        //New York
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(23.0225, 72.5714), title: "New York Pizza", subtitle: "Pizza Comes to America")
        annotation.pizzaPhoto = UIImage(named: "Naples")
        annotation.historyText = "The first known Pizza restaurant in the United States was in New York’s Little Italy. Gennaro Lombardi in 1905 opened his restaurant, but used a coal oven instead of a traditional wood burning oven, since coal was cheaper than wood in New York. New York Pizza breaks several traditions from its Italian ancestor. Most importantly it is sold in large slices, which meant whole pizzas were made larger than the traditional 14inch/35cm diameter. To make a larger pizza, a  higher gluten recipe is used for the crust, and the pizza is tossed in the air with a spinning motion to expand."
        annotations.append(annotation)
        
        //Chicago
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(22.3072, 73.1812), title: "Chicago Deep Dish", subtitle: "No more flat crusts")
        annotation.pizzaPhoto = UIImage(named: "Chicago")
        annotation.historyText = " In 1943, Ike Sewell changed the crust from the thin flatbread to a deep pan, adding traditional Italian/New York  ingredients. Sewell and his cook and eventual manager Rudy Malnati added a layer of sausage to the pan. Some believe the longer cooking time of 20 minutes to 45 minutes of the deep dish meant more beverage consumption, and a higher profit for the restaurant. Deep dish pizza caught on in Chicago, with many competitors in the area. With the 2 inch of deeper pizza crust, the order of ingredients can change between competitors, with a crust ranging in texture from cracker like to bread like and the cheese on top or on the sauce on top."
        annotations.append(annotation)
        
        //Chatham
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(21.1702, 72.8311), title: "Hawaiian/Canandian Pizza", subtitle: "Non-Italian Ingredients")
        annotation.pizzaPhoto = UIImage(named: "Chatham")
        annotation.historyText = "The so-called Hawaiian pizza is not Hawaiian -- It's Canadian. Greek immigrant  to Canada Sam Panopoulos added canned pineapple and Canadian bacon to a pizza in his small restaurant in Chatham, Canada. This is the one of the earliest pizzas without traditional Italian ingredients. As late as 2017, a few months before Panopoulos' death this was controversial, with purists angry about pineapple on a pizza. The president of Iceland started a near diplomatic incident between Canada and Iceland with his statement he would make pineapple on Pizza illegal if he could, with Canadians up in arms about their treasure."
        annotations.append(annotation)
        
        //Beverly Hills
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(22.3039, 70.8022), title: "California Pizza", subtitle: "Is this a pizza?")
        annotation.pizzaPhoto = UIImage(named: "Beverly Hills")
        annotation.historyText = "Californian Fusion cuisine combines elements from many cuisines, and pizza is no exception. Wolfgang Puck hired San Francisco chef Ed LaDou to run the pizza oven at his trendy but exclusive restaurant here when it opened in 1982, and used completely non-traditional ingredients, such as duck sausage and smoked salmon. These pizzas still had a traditional crust. Whlie Queen Margherita may have made it permissible to eat poor peoples food, LaDou made it into rich people’s food."
        annotations.append(annotation)
        
    }
}
