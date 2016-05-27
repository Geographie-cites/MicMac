package org.netlogo.extension.rungeKuta

import org.nlogo.api._
import scala.Array
import org.nlogo.api.Syntax._
import org.nlogo.api.ScalaConversions._

class RungeKuta extends DefaultReporter {
  override def getSyntax(): Syntax =
  Syntax.reporterSyntax(Array(NumberType, NumberType, NumberType, NumberType, NumberType, NumberType), ListType)

  @throws(classOf[ExtensionException])
  @throws(classOf[LogoException])
  override def report(args: Array[Argument], context: Context) =
  {
    val S = args.apply(0).getDoubleValue
    val I = args.apply(1).getDoubleValue
    val R = args.apply(2).getDoubleValue

    val alpha = args.apply(3).getDoubleValue
    val beta = args.apply(4).getDoubleValue
    val h = args.apply(5).getDoubleValue

    rungeKuta4( Array(S,I,R), alpha, beta, h).toLogoList
  }

  def rungeKuta4(init:Array[Double], alpha: Double, beta: Double,h:Double):Array[Double] = {

  val temp = init

   val Q1 = SIR(temp,alpha,beta)

   var sir = (temp zip Q1).map{
     case (t,q1) =>
    t + (h / 2.0) * q1
   }

   val Q2 = SIR(sir, alpha, beta)

    sir = (temp zip Q2).map {
      case (t, q2) =>
        t + (h / 2.0) * q2
    }

    val Q3 = SIR(sir, alpha, beta)

    sir = (temp zip Q3).map {
      case (t, q3) =>
        t + h * q3
    }

    val Q4 = SIR(sir, alpha, beta)

    for (i <- 0 to 2) {
      sir(i) = temp(i) + (h / 6.0) * (Q1(i) + 2.0 * Q2(i) + 2.0 * Q3(i) + Q4(i))
    }

    sir
  }

  def SIR(sir:Array[Double],alpha:Double,beta:Double):Array[Double]= {
    val ds = (- beta * sir(0) * sir(1))
    val di = (beta * sir(0) * sir(1) ) - (alpha * sir(1))

    val dr = (alpha * sir(1))
    Array(ds,di,dr)
  }

}

